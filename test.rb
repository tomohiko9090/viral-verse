require 'selenium-webdriver'

driver = Selenium::WebDriver.for :chrome
driver.navigate.to 'https://www.google.co.jp/maps/place/%E3%82%BF%E3%82%B3%E3%81%A8%E3%83%8F%E3%82%A4%E3%83%9C%E3%83%BC%E3%83%AB+%E5%8C%97%E5%8D%83%E4%BD%8F%E6%9D%B1%E5%8F%A3%E5%BA%97/@35.749267,139.8060617,21z/data=!4m8!3m7!1s0x60188f98dba3c68f:0xf5b65f9fd301a9d0!8m2!3d35.7494244!4d139.8061186!9m1!1b1!16s%2Fg%2F11thnjy729?hl=ja&entry=ttu&g_ep=EgoyMDI0MDkyMy4wIKXMDSoASAFQAw%3D%3D'
sleep 2
# ログイン処理などが必要な場合、ログインを行う
review_button = driver.find_element(:css, '.g88MCb')


# 口コミ欄を開いて指定のテキストを入力
review_button.click

sleep 30
# textarea = driver.find_element(:css, '口コミのテキストエリアのセレクタ')
# textarea.send_keys('ここに指定したテキストを入力')
# submit_button = driver.find_element(:css, '送信ボタンのセレクタ')
# submit_button.click
