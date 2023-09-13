CANAME=MyOrg-RootCA
# optional
mkdir $CANAME
cd $CANAME
# generate aes encrypted private key
openssl genrsa -aes256 -out $CANAME.key 4096

# create certificate, 1826 days = 5 years
# the following will ask for common name, country, ...
openssl req -x509 -new -nodes -key $CANAME.key -sha256 -days 1826 -out $CANAME.crt

sudo cp $CANAME.crt /etc/pki/ca-trust/source/anchors/$CANAME.crt
sudo update-ca-trust

MYCERT=yace-local
openssl req -new -nodes -out $MYCERT.csr -newkey rsa:4096 -keyout $MYCERT.key -subj '/CN=dynamo-local/C=LT/ST=Lithuania/L=Vilnius/O=DB'

cat > $MYCERT.v3.ext << EOF
authorityKeyIdentifier=keyid,issuer
basicConstraints=CA:FALSE
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
subjectAltName = @alt_names
[alt_names]
DNS.1 = dynamodb.local
IP.1 = 127.0.0.1
EOF

openssl x509 -req -in $MYCERT.csr -CA $CANAME.crt -CAkey $CANAME.key -CAcreateserial -out $MYCERT.crt -days 730 -sha256 -extfile $MYCERT.v3.ext
