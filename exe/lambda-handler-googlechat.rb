require_relative '../lib/mackerel-webhook-gateway'
require_relative '../customize'
require 'aws-sdk-kms'
require 'base64'

ENCRYPTED = ENV['GOOGLECHAT_WEBHOOK']
# Decrypt code should run once and variables stored outside of the function
# handler so that these are decrypted once per container
DECRYPTED = Aws::KMS::Client.new.decrypt({
                                           ciphertext_blob: Base64.decode64(ENCRYPTED),
                                           encryption_context: { 'LambdaFunctionName' => ENV['AWS_LAMBDA_FUNCTION_NAME'] }
                                         }).plaintext
ENV['GOOGLECHAT_WEBHOOK'] = DECRYPTED

def lambda_handler(event:, _context:)
  m = MackerelWebhookGateway::GoogleChat.new
  h = m.parse(JSON.generate(event.inspect))
  m.run(h) if h

  { statusCode: 200, body: JSON.generate('received on Lambda') }
end
