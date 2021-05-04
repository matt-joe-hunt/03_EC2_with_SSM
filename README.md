### EC2 deployment with SSM access

## Summary

You can use this simple structure to deploy a simple EC2 instance with Terraform.  As part of this deployment, you will also be creating secure access to your instance by using SSM.

SSM allows you to securely access an EC2 instance without requiring a Bastion Host, making it easier to configure and maintain.

## Instructions

In your terminal run the following commands:

```
terraform init
terraform workspace select dev || terraform workspace new dev
terraform apply
```

The first command will initialise Terraform, we are then either going to select an existing Terraform workspace called 'dev' or create it (in which case we will also automatically be using it).  We finally run the Terraform apply command to create the environment, remember to make sure to confirm the deployment by typing 'yes'.

Once the Terraform apply command has completed, you can go across to the AWS console where you will find that the EC2 instance has been provisioned inside the region defined (by default eu-west-2). You can also now securely access the EC2 instance by using the SSM.

To access the instance, first, select it from the EC2 console and then click the *Connect* button towards the top of the console.  This will take you to a new screen where you can select the way you want to connect, as we have set up SSM, we will make use of the *Session Manager* Option, simply click the *connect* button in the bottom right of the screen.  Lastly, this will open a new tab with a terminal, from this terminal you now have access to your EC2 instance!

## Project Modules

### VPC

Starting with the VPC, this module creates the resources required for setting up a basic VPC.  We will start by looking at the **data.tf** file, we see a data block, this is a special block that returns a list of all the AZ's available with your selected region (in our case eu-west-2).  You don't need to select an AZ like this, however doing so means that we will always select a valid AZ for our Subnet, without having to do any research.  In later sessions we will also see how we could a similar approach to create resources across multiple AZ's, ensuring HA (High Availability).

Next, in the **variables.tf**  we can see 3 variables that we will be using to help us create the resources in the **main.tf** file of the module, these variables are given a value in the **main.tf** file in the root of the project, though we will look at that later.

Looking in the main.tf file, we have an **aws_vpc** resource block, we are defining the CIDR range that our VPC will use by using the cidr_block attribute and referring to the *vpc-cidr-block* variable that we also declare.  We are also setting up dns support and assigning a name to our vpc using a tag.

Moving onto the **aws_subnet** resource block, you can see that we have made use of the Data block we defined earlier in the data.tf file, as well as attaching this subnet to our VPC, and adding a relevant CIDR block.

The next resource block, **aws_internet_gateway** creates the IGW that our VPC will use, remember that you can only have one IGW per VPC.  We have given this IGW a name using Tags so that we can easily refer to it later.

The next 2 resource blocks, **aws_route_table** and **aws_main_route_table_association** will create the route table used by our VPC and attach it.  We have only defined one route in our route table and this is all that we need for this deployment.

In the *outputs.tf* file we have defined 2 output blocks that we will need to use in other areas of our deployment.

### SG

In the **main.tf** file, in the resource block for this module, we are creating the SG that our VPC needs.  Within the **aws_security_group** resource we are creating an Egress rule, this rule allows outgoing communication to the Internet.

We have also created an **aws_security_group_rule** resource, which outlines an Ingress rule for our Security Group.  This rule allows communication to port 443, however only from within the security group itself.  This rule is required for us to enable access via SSM.

Defining a rule like this gives us a little more flexibility, and can let us easily create rules by iterating over a list (more on that later!).   

### EC2

This module will have the most tangible purpose, however, it also relies on the other 2 sections created earlier hence why it has been left to the end.

In the **data.tf** file we are using a special data block to get the AMI id for the ***AMAZON 2*** image available in our region.  Again we could do this without the data block, however as the AMI id's for the *** AMAZON 2*** are different for each region our code would not be particularly portable.  It's also easier than finding the AMI id for the image you want to use, assuming you are using an AWS supplied AMI.

In the **main.tf** filer, the first resource block registers the key pair that we will use to connect to our instance. You do need to ensure that you already have a key pair created on your system, here I have just used the default values when *ssh-keygen* is used.  This step means we can quickly connect to the EC2 instance once it has been created.

The final resource is the **aws_instance** we are creating.  We use a lot of information that we have discussed and defined elsewhere, sometimes in different modules, but if you look at the attributes that we are declaring you should be able to see the structure of the EC2 instance we are creating.