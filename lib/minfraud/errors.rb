# frozen_string_literal: true

module Minfraud
  class BaseError          < StandardError; end

  class NotEnumValueError  < BaseError; end
  class RequestFormatError < BaseError; end
  class ClientError        < BaseError; end
  class AuthorizationError < BaseError; end
  class ServerError        < BaseError; end
end
