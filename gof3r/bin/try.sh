#!/usr/bin/env bash

#set -e
#set -x

WORKING_DIR=`pwd`

echo "WORKING DIR: ${WORKING_DIR}"

rm -Rf tmp/
mkdir -p tmp/{upload,download}

go build -a
mv gof3r tmp/
chmod +x tmp/gof3r

head -c 500 /dev/urandom > "tmp/upload/test1.zip"
head -c 500 /dev/urandom > "tmp/upload/test2 test.zip"
head -c 500 /dev/urandom > "tmp/upload/test3+test.zip"
head -c 500 /dev/urandom > "tmp/upload/test4@test.zip"
head -c 500 /dev/urandom > "tmp/upload/test5\$test.zip"
# head -c 500 /dev/urandom > "tmp/upload/test6%test.zip"
head -c 500 /dev/urandom > "tmp/upload/test7:test.zip"
head -c 500 /dev/urandom > "tmp/upload/test8,test.zip"
head -c 500 /dev/urandom > "tmp/upload/test9&test.zip"
# head -c 500 /dev/urandom > "tmp/upload/test10 +@\$%:,&test.zip"
head -c 500 /dev/urandom > "tmp/upload/test11......................zip"

BUCKET="mpx-tmp-teegi1lah2kei8ej"
REGION="us-east-1"

echo ""

for file in tmp/upload/*.zip; do
    key=${file##*/}

    echo "Uploading ${file} to s3"
    tmp/gof3r put -c 2 -b "${BUCKET}" -k "${key}" -p "${file}"
    if [ $? -eq 0 ]; then
      echo OK
    else
      echo FAIL
    fi

    echo ""
done

for file in tmp/upload/*.zip; do
    key=${file##*/}

    echo "Downloading ${key} from s3"
    tmp/gof3r get -c 2 -b "${BUCKET}" -k "${key}" -p "tmp/download/${key}"
    if [ $? -eq 0 ]; then
      echo OK
    else
      echo FAIL
    fi

    echo ""
done


# tmp/gof3r get -c 10 \
# -b mpx-v2-presentation-affiliation-nbcu \
# -k "originals/2017/09/06/356703/0000/test + PassportAirlineClientUserGuide copy 2.pdf" \
# -p /tmp/test___PassportAirlineClientUserGuide_copy_2.pdf

# tmp/gof3r put -c 10 \
# -b mpx-v2-presentation-affiliation-nbcu \
# -k "originals/2017/09/06/356703/0000/my test + PassportAirlineClientUserGuide copy 2.pdf" \
# -p ./tmp/upload/test.zip

# tmp/gof3r get -c 10 \
# -b mpx-v2-presentation-affiliation-nbcu \
# -k "originals/2017/09/06/356703/0000/my test + PassportAirlineClientUserGuide copy 2.pdf" \
# -p /tmp/test.zip                #
