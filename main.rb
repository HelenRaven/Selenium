require 'selenium-webdriver'
require 'csv'

options = Selenium::WebDriver::Chrome::Options.new
options.add_argument("--disable-blink-features")
options.add_argument("--disable-blink-features=AutomationControlled")

@driver = Selenium::WebDriver.for :chrome, options: options
@driver.execute_script("Object.defineProperty(navigator, 'webdriver', {get: () => undefined})")
@driver.manage.window.maximize
@driver.manage.timeouts.implicit_wait = 10

def slow_scroll(element)
  scheight = 10
  y = element.rect.y - element.rect.height

  while scheight >= 0.7
    @driver.execute_script("window.scrollTo(0,#{y/scheight})")
    scheight -= 0.1
  end
  @driver.action.move_to(element).perform
end

def load_pre_open_market_to_csv
  @driver.get 'https://www.nseindia.com/'

  market_data = @driver.find_element(:link_text, 'MARKET DATA')
  @driver.action.move_to(market_data).perform

  @driver.find_element(:link_text, 'Pre-Open Market').click

  rows = [['name', 'price']]
  sleep(1)

  table = @driver.find_elements(:css, "table#livePreTable tbody tr")

  table.each do |tr|
    tds = tr.find_elements(:css, 'td')
    name = tds[1].find_element(:css, 'a').text
    price = tds[6].text.tr(',','')
    rows << [name, price]
  end

  File.write("file.csv", rows.map(&:to_csv).join)
end


def user_scenary
  @driver.get 'https://www.nseindia.com/'

  nifty_bank = @driver.find_element(:css, '[href="#NIFTY BANK"]')
  slow_scroll(nifty_bank)
  nifty_bank.click

  view_all = @driver.find_element(:css, 'div#tab4_gainers_loosers img')
  slow_scroll( view_all)
  view_all.click

  select_element = @driver.find_element(id: 'equitieStockSelect')
  select_object = Selenium::WebDriver::Support::Select.new(select_element)
  select_object.select_by(:text, 'NIFTY ALPHA 50')

  sleep(1)
end


begin
  load_pre_open_market_to_csv
  user_scenary
ensure
  @driver.quit
end
