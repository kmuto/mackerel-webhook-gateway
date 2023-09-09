require_relative '../lib/saba-webhook-gateway'
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

# rubocop:disable Lint/UnusedMethodArgument
def lambda_handler(event:, context:)
  m = SabaWebhookGateway::GoogleChat.new
  h = m.parse(JSON.generate(event))
  if h[:body]
    m.run(m.parse(h[:body]))
  elsif h[:event]
    m.run(h)
  end

  { statusCode: 200, body: JSON.generate('received on Lambda') }
end
# rubocop:enable Lint/UnusedMethodArgument
