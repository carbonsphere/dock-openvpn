Author  : CarbonSphere <br>
Email   : carbonsphere@gmail.com<br>

# OpenVPN Docker

### docker pull carbonsphere/dock-openvpn
### Dockerfile Source: https://github.com/carbonsphere/dock-openvpn.git

## RUN notice and procedure

  - Pull containers

    1. docker pull carbonsphere/dock-openvpn or you can build it from Dockerfile.

    2. docker pull carbonsphere/dock-easy-rsa (Optional - If you have required CA keys and certs)
      Note: Required CA & Server Certificates/Keys can be generated using "carbonsphere/dock-easy-rsa" or you can build it yourself by downloading from github "https://github.com/carbonsphere/dock-easy-rsa.git".
      dock-easy-rsa.git also contains example script to help you generate a set of default OpenVPN certificates and keys.

  - Required configuration files

    - OpenVPN requires the following files to start.

      ca.crt        # CA Certificate
      server.crt    # Server Certificate
      server.key    # Server Private Key
      dh2048.pem    # Diffie hellman parameters
      server.conf   # Server configuration.  You can use "server.conf.example" to start from.

      These filenames can be changed and should match server.conf parameters

  - Start Server

    - Have all the configuration files in a directory. Then we'll mount that directory as a volume with path "/etc/openvpn" into dock-openvpn

    EX:  I have my files in ./my_openvpn_conf/
      docker run -d -p 1194:1194/tcp -v $(pwd)/my_open_vpn_conf:/etc/openvpn --cap-add=NET_ADMIN --name openvpn carbonsphere/dock-openvpn

      Note: Becareful on $(pwd). Since you'll need to change directory into relative path in order for this to run correctly or else openvpn container will not start.

    - Docker parameter used
      cap-add = NET_ADMIN # Allows access to docker interface on host.
      name = openvpn      # Always name your container for ease of follow up like stop and remove.

  - Default configuration (in server.conf.example)

    - Ports 1194
    - Protocol TCP  # Default is TCP since that is what I use on my environment. You can change it to UDP, just besure to match it in client.ovpn
    - dev tun
    - No push routes 
    - dhcp-option default to 8.8.8.8 and 8.8.4.4
    - Enabled client-to-client
    - "redirect-gateway def1 bypass-dhcp" is DISABLED since it will interfere with my test environment and create a loop. 

    Note: You can change any of these parameters in server.conf but besure to match it with client.ovpn

    - Default examples of server/client configuration is provided in ./openvpn

  - Client Certificate

    - "carbonsphere/dock-easy-rsa" can help you generate additional client ovpn configuration file with certificate and key based on your CA. Check dock-easy-rsa documentation for more information. 


This is a docker container source file. This container allows you to start your own VPN server without mess. This container uses Centos6. Certificates and key generation is seperated into another container at "carbonsphere/dock-easy-rsa". Check its README for howto generate CA and Server certificate/key.
