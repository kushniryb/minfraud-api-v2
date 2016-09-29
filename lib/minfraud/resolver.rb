module Minfraud
  module Resolver
    class << self
      # @param [Object] context an object for variable assignment
      # @param [Hash] params a hash of parameters
      # @return [Array] a list of supplied params
      # Note: Raises RequestFormatError once unpermitted key is met
      def assign(context:, params:)
        Array(params).each do |key, value|
          raise RequestFormatError, "#{key} does not belong to request document format" unless MAPPING[key]

          entity = MAPPING[key].new(value) unless value.is_a?(MAPPING[key])
          context.send("#{key}=", entity || value)
        end
      end
    end

    # Mapping between components & minFraud request keys
    MAPPING = {
      account:            ::Minfraud::Components::Account,
      billing:            ::Minfraud::Components::Billing,
      credit_card:        ::Minfraud::Components::CreditCard,
      device:             ::Minfraud::Components::Device,
      email:              ::Minfraud::Components::Email,
      event:              ::Minfraud::Components::Event,
      order:              ::Minfraud::Components::Order,
      payment:            ::Minfraud::Components::Payment,
      shipping:           ::Minfraud::Components::Shipping,
      shopping_cart:      ::Minfraud::Components::ShoppingCart
    }
  end
end