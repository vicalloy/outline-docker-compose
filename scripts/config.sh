URL=http://localhost:8888
DEFAULT_LANGUAGE=en_US
FORCE_HTTPS=false

# Nginx
HTTP_IP=127.0.0.1
HTTP_PORT_IP=8888

# Global
NETWORKS=outlinewiki
NETWORKS_EXTERNAL=false

# OIDC
OIDC_CLIENT_ID=cid_from_oidc_provider
OIDC_CLIENT_SECRET=secret_from_oidc_provider
OIDC_AUTH_URI=http://192.168.x.x:8000/oauth/authorize/
OIDC_TOKEN_URI=http://192.168.x.x:8000/oauth/token/
OIDC_USERINFO_URI=http://192.168.x.x:8000/oauth/userinfo/
OIDC_DISPLAY_NAME=OpenID

# MinIO
MINIO_BROWSER=on
MINIO_HTTP_IP=127.0.0.1
MINIO_HTTP_PORT=19001
