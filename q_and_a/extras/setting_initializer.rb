require 'singleton'
require 'yaml'
require 'erb'

class SettingInitializer
  include Singleton

  attr_reader :font_path

  def initialize
    msg = "設定ファイルが存在しません。下記位置にファイルを作成してください。\n  #{File.join(Rails.root, 'config', 'constants.yml')}"
    fail msg  unless File.exists?(File.join(Rails.root, 'config', 'constants.yml'))

    data = HashWithIndifferentAccess.new(
      YAML.load(ERB.new(File.read(File.join(Rails.root, 'config', 'constants.yml'))).result)
    )[Rails.env]

    # 認証基盤の設定
    @font_path = data[:font_path]

    errors = []
    errors << 'PDF出力用の日本のフォントのパスが設定されていません' if @font_path.blank?

    unless errors.empty?
      fail errors.join('')
    end
  end
end
