require 'single_cov'
SingleCov.setup :rspec

describe 'Coverage' do
  it 'does not let users add new untested code' do
    SingleCov.assert_used
  end
end
