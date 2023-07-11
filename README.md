
# Administration of self-hosted matrix-synapse on digital ocean



**Table of Contents**
  - [registration]
    - [commandline]
    - [API]
  - [access_token]

## registration
1. ### commandline
    This requires *register_new_matrix_user* client and **homeserver.yaml** file which has the shared registration secret.
    - Example: Non-admin with password as argument <br>
    `register_new_matrix_user -u <user> -p <password> -c /etc/matrix-synapse/homeserver.yaml --no-admin <URLofhomeserver>`
    - Example: admin with password input <br>
    `register_new_matrix_user -u <user> -c /etc/matrix-synapse/homeserver.yaml -a <URLofhomeserver>`
    - Example: get help <br>
    `register_new_matrix_user --help`

2. ### API
    This is a three step procedure. Use postman or curl
    - #### GET NONCE
        `GET <URLofhomeserver>/_synapse/admin/v1/register`
    - #### GET HMAC using shared secret
        use example bash script **hmacdigest.sh** to calculate hmac. set shared secret in environment variable shared_secret.<br>
        export shared_secret='*sharedsecret*'<br>
        <br>It takes 4 arguments in conjunction with an environment variable<br>
        nonce, username, password, admin/notadmin <br>
        
        We do this because we don't want to share our secret in the POST request so we use it to get hashed value of all the parameters.

    - #### POST request
        ```
        POST /_synapse/admin/v1/register
        {
        "nonce": "thisisanonce",
        "username": "pepper_roni",
        "displayname": "Pepper Roni",
        "password": "pizza",
        "admin": false,
        "mac": "mac_digest_here"
        }
        ```


More details can be obtained from the official documentation https://matrix-org.github.io/synapse/v1.59/admin_api/register_api.html



## access_token
you can get access token as the output of your POST request <br> 
or <br>
you can get it from the element client. This has a short life <br>
Click on Top Right of User > All Settings > Help and About > Advanced <br>