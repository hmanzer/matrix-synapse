
# Administration of self-hosted matrix-synapse on digital ocean



**Table of Contents**
  - [registration]
    - [commandline]
    - [API]
  - [access_token]
  - [maintenance]
    - [media]
    - [events]
  - [database]


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
We need acess token to use all admin APIs.
you can get access token as the output of your POST request <br> 
or <br>
you can get it from the element client. This has a short life <br>
Click on Top Right of User > All Settings > Help and About > Advanced <br>

## maintenance

1. ### media

    #### purge local media
    ```
    POST /_synapse/admin/v1/media/<server_name>/delete?before_ts=<before_ts>
    {}
    ```
    #### purge remote media
    ```
    POST /_synapse/admin/v1/purge_media_cache?before_ts=<unix_timestamp_in_ms>
    {}
    ```
2. ### events
    #### purge history
    The API is:


    POST /_synapse/admin/v1/purge_history/<room_id>[/<event_id>]
    By default, events sent by local users are not deleted, as they may represent the only copies of this content in existence. (Events sent by remote users are deleted.)

    Room state data (such as joins, leaves, topic) is always preserved.

    To delete local message events as well, set delete_local_events in the body:


    {
    "delete_local_events": true
    }
    The caller must specify the point in the room to purge up to. This can be specified by including an event_id in the URI, or by setting a purge_up_to_event_id or purge_up_to_ts in the request body. If an event id is given, that event (and others at the same graph depth) will be retained. If purge_up_to_ts is given, it should be a timestamp since the unix epoch, in milliseconds.

    The API starts the purge running, and returns immediately with a JSON body with a purge id


## database
To reclaim the disk space and return it to the operating system, you need to run VACUUM FULL; on the database.



