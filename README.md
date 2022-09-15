With this Terraform file, you can create a server on DigitalOcean and have the IPv4 address of the created server added to your domain name on CloudFlare. While creating the server, your SSH keys that you have added to DigitalOcean before are added to the server and the install.sh file is created in the /root directory. After running the install.sh file, OpenVPN Access Server is installed on the server, then Lets Encrypt SSL certificate is generated together with acme.sh and SSL certificate is installed on the OpenVPN service. Also, the server is set up with AdGuard DNS addresses. You can surf the internet without any ads during VPN connection.

## How to use

1. Rename secret_variables.tf.example file to secret_variables.tf.
2. Create a DigitalOcean account and add your SSH keys to DigitalOcean.
3. Create a CloudFlare account and add your domain name to CloudFlare.
4. Create a DigitalOcean API token and add it to the DigitalOcean API token field in the secret_variables.tf Terraform file.
5. Create a CloudFlare API token and add it to the CloudFlare API token field in the secret_variables.tf Terraform file.
6. Add your domain name to the domain field in the secret_variables.tf Terraform file.
7. Run the Terraform file with the following command:

    ```bash
    terraform init
    terraform apply
    ```
8. After the Terraform file is finished, you can connect to the server with the following command:

    ```bash
    ssh root@<server_ip_address>
    ```
9. Run the install.sh file with the following command:

    ```bash
   sh install.sh
    ```
10. If you want to delete the server, you can run the following command:

   ```bash
   terraform destroy
   ```