#!/bin/bash

#Tempat menyimpan file log
log_file="/home/namauser/ocsp_log/ocsp.log"

timestamp=$(date +"%Y-%m-%d %H:%M:%S")

#sertifikat profile
root="/home/namauser/PrivyCAClass3G2.pem"

#sertifikat profile chain
chain="/home/namauser/PrivyCAClass3G2-chain.pem"

#sertifikat user
cert="/home/namauser/AS11111.pem"

# Telegram Bot API configuration
TELEGRAM_BOT_TOKEN="" #Ganti dengan Bot token anda
TELEGRAM_CHAT_ID="" # Ganti dengan CHAT ID anda
THREAD_ID="3962"  # Ganti dengan Thread ID anda

# Command OCSP
openssl ocsp -issuer $root -cert $cert -CAfile $chain -nonce -text -url https://ocsp.privyca.id >/dev/null 2>&1

# Checking the exit code of the OCSP command
if [ $? -eq 0 ]; then
    echo "$timestamp : Hit OCSP Successful" >> "$log_file"
    echo "Sukses"
#    message="$timestamp%0AMessage : Hit OCSP Success"
else
    echo "$timestamp : Hit OCSP Failed" >> "$log_file"
    message="$timestamp%0AMessage : Hit OCSP Failed!!!"
fi

# Send message to Telegram with Thread ID
curl -s -X POST "https://api.telegram.org/bot${TELEGRAM_BOT_TOKEN}/sendMessage" \
    -d "chat_id=${TELEGRAM_CHAT_ID}" \
    -d "text=${message}" \
    -d "reply_to_message_id=${THREAD_ID}"
