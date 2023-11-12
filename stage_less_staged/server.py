import dns.query
import dns.tsigkeyring
import dns.update

def send_dns_txt_record(txt_record, target_machine_ip, tsig_keyname, tsig_secret):

    update = dns.update.Update()

    update.add("", 300, dns.rdatatype.TXT,txt_record)

    response = dns.query.tcp(update, target_machine_ip, keyring=dns.tsigkeyring.from_text({tsig_keyname: tsig_secret}))

    if response.rcode() == dns.rcode.NOERROR:
        print("DNS TXT record sent successfully.")
    else:
        print("Failed to send DNS TXT record. Response code:", dns.rcode.to_text(response.rcode()))

txt_record = "Hello, World!"
target_machine_ip = "192.168.8.105"
tsig_keyname = "aGk="
tsig_secret = "aGk="

send_dns_txt_record(txt_record, target_machine_ip, tsig_keyname, tsig_secret)
