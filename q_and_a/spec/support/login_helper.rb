# 指定されたログイン名とオプションを元に MaintenanceUser のモックを作成しログイン
def mock_logined_user(opts = {})
  default_opts = {
    name: 'テスト利用者',
    name_kana: 'テストリヨウシャ',
    login: 'test',
    password: 'password'
  }
  default_opts.merge(opts)

  mock_user = mock_model(User, default_opts)
  mock_user
end

def logined_by(user)
  allow(controller).to receive(:check_login).and_return(user)
end
