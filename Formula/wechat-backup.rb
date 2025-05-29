class WechatBackup < Formula
  desc "Automatically backup WeChat images and videos to a specified directory"
  homepage "https://github.com/zhilu-tang/wechat-backup"
  url "https://github.com/zhilu-tang/wechat-backup/archive/v1.0.0.tar.gz"
  sha256 "979f808243ecf07dc600dfed8485f0d876a412a809675b289f09efd92be17798"

  depends_on "python@3.9" => :build

  def install
    bin.install "dist/wechat-backup"
    bin.install "dist/wechat-backup-manage"

    # 创建 launchd 配置文件
    (prefix/"com.zhilu.tang.wechat-backup.plist").write <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>com.zhilu.tang.wechat-backup</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{bin}/wechat-backup</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
        <key>StandardOutPath</key>
        <string>/tmp/wechat-backup.log</string>
        <key>StandardErrorPath</key>
        <string>/tmp/wechat-backup.log</string>
      </dict>
      </plist>
    EOS
  end

  def caveats
    <<~EOS
      To have launchd start wechat-backup now and restart at login:
        brew services start wechat-backup
      Or, if you don't want/need a background service you can just run:
        #{bin}/wechat-backup
    EOS
  end

  test do
    system "#{bin}/wechat-backup", "--version"
  end
end