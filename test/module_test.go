package test

import (
	"fmt"
	"strings"
	"testing"
	"time"

	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/ssh"
	"github.com/gruntwork-io/terratest/modules/terraform"
	test_structure "github.com/gruntwork-io/terratest/modules/test-structure"
	"github.com/stretchr/testify/assert"
)

func TestTerraformEc2Module(t *testing.T) {
	t.Parallel()

	modulePath := test_structure.CopyTerraformFolderToTemp(t, "../", ".") 
	region := "us-east-1"
	uniqueID := strings.ToLower(random.UniqueId())
	namespace := fmt.Sprintf("test-%s", uniqueID)

	// -----------------------------------------------
	// Teardown
	// -----------------------------------------------
	defer test_structure.RunTestStage(t, "teardown", func() {
		options := test_structure.LoadTerraformOptions(t, modulePath)
		terraform.Destroy(t, options)

	})

	// -----------------------------------------------
	// Setup
	// -----------------------------------------------
	test_structure.RunTestStage(t, "setup", func() {

		options := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
			TerraformDir: modulePath,
			Vars: map[string]interface{}{
				"namespace":                  namespace,
				"vpc_cidr_block":             "10.0.0.0/16",
				"subnet_cidr_block":          "10.0.1.0/24",
				"map_public_ip":              true,
				"availability_zone":          fmt.Sprintf("%sa", region),
				"ami_id":            "ami-0e449927258d45bc4",
				"key_name":                   "test-key",
				"allowed_ssh_cidrs":          []string{"0.0.0.0/0"},
				"egress_rules":               []map[string]interface{}{
					{
						"from_port":   0,
						"to_port":     0,
						"protocol":    "-1", 
						"cidr_blocks": []string{"0.0.0.0/0"}, 
						"description": "Allow all outbound traffic. Not recommended.",
					},
				},
				"common_tags":               map[string]string{"env": "test"},
				"instance_tags":             map[string]string{"purpose": "terratest"},
				"save_private_key_to_file":   false,
			},
			EnvVars: map[string]string{
				"AWS_DEFAULT_REGION": region,
				"AWS_PROFILE": "terraform-user",
			},
		})

		test_structure.SaveTerraformOptions(t, modulePath, options)

		terraform.InitAndApply(t, options)
	})

	// -----------------------------------------------
	// Validate
	// -----------------------------------------------
	
		test_structure.RunTestStage(t, "validate", func() {
		options := test_structure.LoadTerraformOptions(t, modulePath)
		

		instanceID := terraform.Output(t, options, "instance_id")
		publicIP := terraform.Output(t, options, "instance_public_ip")
		privateKey := terraform.Output(t, options, "ssh_private_key")

		assert.NotEmpty(t, instanceID)
		assert.NotEmpty(t, publicIP)
		assert.NotEmpty(t,privateKey)

		keyPair := ssh.KeyPair{
			PrivateKey: string(privateKey),
	  }

		// SSH Connectivity
		host := ssh.Host{
			Hostname:    publicIP,
			SshUserName: "ec2-user", 
			SshKeyPair:  &keyPair,
		}

		// Retry jusqu'à ce que l'instance soit accessible
		ssh.CheckSshCommandWithRetry(t, host, "echo 'SSH OK'", 10, 10*time.Second)

		// Commande de test
		output := ssh.CheckSshCommand(t, host, "echo 'hello'")
		assert.Equal(t, "hello", strings.TrimSpace(output))
	})

}
