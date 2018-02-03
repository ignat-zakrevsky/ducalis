# frozen_string_literal: true

require 'spec_helper'
require './lib/ducalis/cops/public_send'

RSpec.describe Ducalis::PublicSend do
  subject(:cop) { described_class.new }

  it '[rule] raises if send method used in code' do
    inspect_source(cop, 'user.send(action)')
    expect(cop).to raise_violation(/using `send`/)
  end
end
