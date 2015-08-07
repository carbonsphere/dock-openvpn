Author  : CarbonSphere <br>
Email   : carbonsphere@gmail.com<br>

# OpenVPN Docker

  OpenVPN Server in a container! This container let's you quickly setup a VNP server on the fly. Comes with complete working example scripts that will generate all required certificates and keys for your OpenVPN server. 

* Example scripts requires "carbonsphere/dock-easy-rsa":

		docker pull carbonsphere/dock-easy-rsa

* Easy RSA source code location:

		https://github.com/carbonsphere/dock-easy-rsa.git

* Container location:

		docker pull carbonsphere/dock-openvpn

* Source code location: 

		https://github.com/carbonsphere/dock-openvpn.git


### RUN notice and procedure

* Pull containers

  - Download OpenVPN Container

				docker pull carbonsphere/dock-openvpn

  - Download Easy RSA Container (Optional - If you have required CA keys and certs)

				docker pull carbonsphere/dock-easy-rsa

  - Required configuration files

     - OpenVPN requires the following files to start.

      - ca.crt        # CA Certificate
      - server.crt    # Server Certificate
      - server.key    # Server Private Key
      - dh2048.pem    # Diffie hellman parameters
      - server.conf   # Server configuration.  You can use "server.conf.example" to start from.

      These filenames can be changed and should match server.conf parameters

  - Example File (Example files uses another container "carbonsphere/dock-easy-rsa")

    - Example scripts are now included in this image. To copy example scripts run the commands below.

      1. Make a directory.  

				mkdir my_openvpn_conf

      2. Copy example files into my_openvpn_conf 

				docker run --rm -it -v $(pwd)/my_openvpn_conf:/dest carbonsphere/dock-openvpn cp_example.sh

      3. Change directory into my_openvpn_conf

				cd my_openvpn_conf

      4. Run CA generation script to complete generate CA/Server certificates/keys and DH

				./gen_ca_init.sh

      4. After script execution, you should now have ca.crt server.crt server.key dh2048.pem. We are ready to start openvpn server! (You can press enter on all questions except [y/n]. Must press 'y' to generate required files)

      5. Back out of the directory and follow Start Server procedure.

				cd ..

* Start Server

	- Have all the configuration files in a directory. Then we'll mount that directory as a volume with path "/etc/openvpn" into dock-openvpn

			docker run -d -p 1194:1194/tcp -v $(pwd)/my_open_vpn_conf:/etc/openvpn --cap-add=NET_ADMIN --name openvpn carbonsphere/dock-openvpn

		Note: Becareful on $(pwd). Since you'll need to change directory into relative path in order for this to run correctly or else openvpn container will not start.

	- Docker parameter used

			cap-add = NET_ADMIN # Allows access to docker interface on host.
			name = openvpn      # Always name your container for ease of follow up like stop and remove.

* Default configuration (in server.conf.example)

	- Ports 1194

	- Protocol TCP  # Default is TCP since that is what I use on my environment. You can 
change it to UDP, just besure to match it in client.ovpn

	- dev tun

	- No push routes 

	- dhcp-option default to 8.8.8.8 and 8.8.4.4

	- Enabled client-to-client

	- "redirect-gateway def1 bypass-dhcp" is DISABLED since it will interfere with my test environment and create a loop. 

    Note: You can change any of these parameters in server.conf but besure to match it with client.ovpn

	- Default examples of server/client configuration is provided in ./openvpn

* Client Certificate

	- "carbonsphere/dock-easy-rsa" can help you generate additional client ovpn configuration file with certificate and key based on your CA. Check dock-easy-rsa documentation for more information. 

### Certificates and Services seperation.

* These containers are designed to separate cert/key generation tools, vpn services, and the actual cert/key and server configuration file. You can just backup your cert/key and server configuration files without mess. On the new environment, just download dock-easy-rsa if you need to generate more client certificates.

