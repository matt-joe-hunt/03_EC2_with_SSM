## Instructions

Ensure you have Terraform install on your system

Create a file in the root of the project called **terraform.tfvars**, add the following to the file:
```
project = {
  dev = "project-name"
}

instance-type = {
  dev = "t2.micro"
}
```
(We shouldn't put a .tfvars fiel in source control hence why the .gitignore file omits it)

```
export ENV=dev
terraform init --backend-config=configuration/$ENV.conf
terraform workspace select $ENV || terraform workspace new $ENV
terraform apply
```
Then via your AWS console you will be able to connect to the instance using the Session Manager.  Once connected run the commands below to install and start JMeter

```
sudo yum install git -y
sudo amazon-linux-extras install java-openjdk11 -y
git clone https://github.com/cfpb/jmeter-bootstrap.git && cd jmeter-bootstrap
python bin/JMeterInstaller.py
```

