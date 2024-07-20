# Deploying Layered Security in AWS VPC with Terraform

## Overview

This beginner-friendly project demonstrates how to configure layered security in an AWS Virtual Private Cloud (VPC) using Terraform. It covers creating a VPC, setting up public and private subnets, and implementing security measures such as security groups and network ACLs. Follow this guide to manage VPC resources and secure your cloud environment efficiently.

## Prerequisites

1. **Terraform Installation**

   Install Terraform on your local machine by following the official guide by HashiCorp:
   - [Install Terraform using CLI](https://learn.hashicorp.com/tutorials/terraform/install-cli)
   - [Download Terraform](https://www.terraform.io/downloads.html)

2. **Visual Studio Code Installation**

   Download and install Visual Studio Code by following this guide:
   - [Download Visual Studio Code](https://code.visualstudio.com/download)

## Task Details

1. **Sign in to AWS Management Console**

   - Access the AWS Management Console at [AWS Console](https://aws.amazon.com/console/).

2. **Setup Visual Studio Code**

   - Open Visual Studio Code and configure it for your Terraform project.

3. **Create a `variables.tf` File**

   - Define your variables in a `variables.tf` file.

4. **Create a VPC**

   - Define the VPC in the `main.tf` file.

5. **Create and Attach an Internet Gateway**

   - Add the Internet Gateway configuration in the `main.tf` file.

6. **Create Public and Private Subnets**

   - Define the public and private subnets in the `main.tf` file.

7. **Create Public and Private Route Tables**

   - Configure public and private route tables and associate them with the respective subnets in the `main.tf` file.

8. **Create and Configure Security Group**

   - Define the security group in the `main.tf` file.

9. **Create and Configure Network ACL**

   - Add the Network ACL configuration in the `main.tf` file.

10. **Launch Public and Private EC2 Instances**

    - Define and launch public and private EC2 instances in the `main.tf` file.

11. **Test the EC2 Instances**

    - Verify that the EC2 instances are running correctly.

12. **Create an `output.tf` File**

    - Specify the output variables in an `output.tf` file to obtain useful information about the deployed resources.

13. **Confirm Terraform Installation**

    - Verify the installation by checking the version:
      ```bash
      terraform version
      ```

14. **Apply Terraform Configurations**

    - Execute the Terraform commands to apply the configurations:
      ```bash
      terraform init
      terraform apply
      ```

15. **Check AWS Resources**

    - Verify the created VPC, subnets, route tables, and EC2 instances in the AWS Management Console.

16. **Delete Resources**

    - Remove the resources by executing:
      ```bash
      terraform destroy
      ```

## Cost Considerations

Be aware that creating and managing AWS resources may incur costs. Review and understand the pricing for VPC, EC2 instances, and other related services you are using. Always delete resources when they are no longer needed to avoid unnecessary charges.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## Notes

- Ensure you follow best practices for managing AWS resources and Terraform configurations.
- For additional help, refer to the official [Terraform Documentation](https://www.terraform.io/docs) and [AWS Documentation](https://docs.aws.amazon.com/), or seek support from the community.
