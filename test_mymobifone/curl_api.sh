curl -v -d "phone=X" --insecure  -H "apisecret: X"  -H "Content-Type: application/x-www-form-urlencoded" -X POST https://api.mobifone.vn/api/auth/getloginotp | python -mjson.tool
curl  -k -d "phone=X&otp=Y" -H "apisecret: X"  -H "Content-Type: application/x-www-form-urlencoded" -X POST https://api.mobifone.vn/api/auth/otplogin  | python -mjson.tool
