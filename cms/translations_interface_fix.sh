# A temporary hack because I cant get directus to run like I want to
# It forces norwegian to be the default langauge on the "translations" interface

# Searching for:
# language"in f.currentUser&&ne[re]===f.currentUser.language))==null?void 0:fe[re];y.value=oe
# Replacing with:
# language"in f.currentUser&&ne[re]===f.currentUser.language))==null?void 0:fe[re];y.value="no"

# Escaped with: https://dwaves.de/tools/escape/

echo "Fixing the translation interface..."
find ./node_modules/@directus/app/dist/assets -type f -exec sed -i.bak 's/language"in f\.currentUser\&\&ne\[re\]===f\.currentUser\.language))==null?void 0:fe\[re\];y\.value=oe/language"in f\.currentUser\&\&ne\[re\]===f\.currentUser\.language))==null?void 0:fe\[re\];y\.value="no"/g' {} \;

