require 'helper'
require 'neon_mob'

class TestNeonMob < Minitest::Test
  def setup
    @adapter = Minitest::Mock.new
    @response = Minitest::Mock.new
    @subject = NeonMob.new('some_user', 'some_password')
    @adapter.expect :post, @response, ['https://www.neonmob.com/api/signin/',
                             {
                              :json => {
                                :username => 'some_user',
                                :password => 'some_password',
                              }
                            }]
  end

  def test_initialize_with_params
    assert NeonMob.new('user', 'password')
  end

  def test_initialize_raises_error_without_params
    assert_raises(ArgumentError) { NeonMob.new }
  end

  def test_login_succeeds
    payload = {'redirect' => '/'}
    @response.expect :parse, payload
    HTTP.stub :[], @adapter do
      assert_equal(payload, @subject.login)
    end
    @adapter.verify
    @response.verify
  end

  def test_login_fails
    payload = {'code'=>'INVALID_LOGIN', 'field_errors'=>{}, 'detail'=>'Invalid login details, partner.'}
    @response.expect :parse, payload
    HTTP.stub :[], @adapter do
      assert_equal(payload, @subject.login)
    end
    @adapter.verify
    @response.verify
  end
end
