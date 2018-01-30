require 'securerandom'

SecureRandom.uuid
def unique_url
  uid = SecureRandom.uuid
  "http://example.com/" + uid
end