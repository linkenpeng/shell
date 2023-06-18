# https://developers.weixin.qq.com/miniprogram/dev/devtools/ci.html

# jenkins构建 http://www.manongjc.com/detail/20-iihtxiqhusdyjeo.html

source ~/.bash_profile

rm -f package-lock.json
node -v

npm install --unsafe-perm=true --allow-root

rm -rf ./dist/weapp

sed -i 's/CDN_ACCESS_KEY_PLACEHOLDER/abc123/g' $WORKSPACE/.env
sed -i 's/CDN_SECRET_KEY_PLACEHOLDER/abc123/g' $WORKSPACE/.env

npm run build:weapp:${env}

yes | cp ./upload/wxci.js ./dist/
yes | cp ./upload/package.json ./dist/

cd ./dist
npm install --unsafe-perm=true --allow-root

rm -rf qrcode*.jpg
pwd && ls

if [ "$env" == "uat" ]; then
	node wxci type=$action appkey=$appkey appid=$appid version=$version desc=$desc buildId=${BUILD_ID}
fi

cd $WORKSPACE
mkdir -p qrcodes

if [ "$env" == "uat" ]; then
	cp dist/qrcode-${BUILD_ID}.jpg qrcodes/
fi

tar cf app.tar.gz dist/weapp/