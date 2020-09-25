# frozen_string_literal: true

require 'spec_helper'
require 'webmock/rspec'

WebMock.disable_net_connect!(allow_localhost: true)

describe Minfraud::Assessments do
  it 'makes a successful HTTP request' do
    stub_request(:post, /score/).with(
      body:    '{"device":{"ip_address":"1.2.3.4"}}',
      headers: {
        'Authorization' => 'Basic MTE6bXlfbGljZW5zZV9rZXk=',
      },
    ).to_return(
      body:    '{"risk_score":42.1}',
      headers: {
        'Content-Type' => 'application/vnd.maxmind.com-minfraud-score+json; charset=UTF-8; version=2.0',
      },
      status:  200,
    )

    Minfraud.configure do |c|
      c.account_id        = 11
      c.license_key       = 'my_license_key'
      c.enable_validation = true
    end

    assessment = Minfraud::Assessments.new(
      device: {
        ip_address: '1.2.3.4',
      },
    )

    score_model = assessment.score.body

    expect(score_model.risk_score).to eq 42.1
  end

  it 'makes an HTTP request resulting in an HTTP 400' do
    stub_request(:post, /score/).with(
      body:    '{"device":{"ip_address":"1.2.3"}}',
      headers: {
        'Authorization' => 'Basic MTE6bXlfbGljZW5zZV9rZXk=',
      },
    ).to_return(
      body:    '{"code":"IP_ADDRESS_INVALID","error":"The value \'1.2.3\' is not a valid IP address."}',
      headers: {
        'Content-Type' => 'application/vnd.maxmind.com-error+json; charset=UTF-8; version=2.0',
      },
      status:  400,
    )

    Minfraud.configure do |c|
      c.account_id        = 11
      c.license_key       = 'my_license_key'
      c.enable_validation = false
    end

    assessment = Minfraud::Assessments.new(
      device: {
        ip_address: '1.2.3',
      },
    )

    expect { assessment.score }.to raise_error(Minfraud::ClientError)
  end
end