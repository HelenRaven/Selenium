require 'selenium-webdriver'
require 'csv'

options = Selenium::WebDriver::Chrome::Options.new
options.add_argument('--disable-blink-features')
options.add_argument('--disable-blink-features=AutomationControlled')

@driver = Selenium::WebDriver.for :chrome, options: options
@driver.execute_script("Object.defineProperty(navigator, 'webdriver', {get: () => undefined})")
@driver.manage.window.maximize

@wait = Selenium::WebDriver::Wait.new(timeout: 10)

def slow_scroll(element)
  win_height = @driver.manage.window.size.height
  el_height = element.rect.height
  @driver.execute_script("window.scrollTo(0,#{element.rect.y - win_height / 2 + el_height / 2}, { behavior: 'smooth'})")
  sleep(2)
end

def load_pre_open_market_to_csv
  @driver.get 'https://www.nseindia.com/'

  market_data = @wait.until{ @driver.find_element(:link_text, 'MARKET DATA')}
  sleep(1)
  @driver.action.move_to(market_data).perform

  pre_open = @wait.until{ @driver.find_element(:link_text, 'Pre-Open Market')}
  sleep(1)
  @driver.action.move_to(pre_open).perform
  pre_open.click

  rows = [%w[name price]]

  tb = @wait.until{ @driver.find_element(:css, 'div#table-preOpen')}
  slow_scroll(tb)

  table = @driver.find_elements(:css, 'table#livePreTable tbody tr')

  table.each do |tr|
    tds = tr.find_elements(:css, 'td')
    name = tds[1].find_element(:css, 'a').text
    price = tds[6].text.tr(',', '')
    rows << [name, price]
  end

  File.write('file.csv', rows.map(&:to_csv).join)

  sleep(2)
end

def user_scenary
  @driver.get 'https://www.nseindia.com/'

  graph = @wait.until{ @driver.find_element(:css, 'div#tab1_container') }
  slow_scroll(graph)

  nifty_bank = @wait.until{ @driver.find_element(:css, '[href="#NIFTY BANK"]') }
  slow_scroll(nifty_bank)
  nifty_bank.click

  tb = @wait.until{@driver.find_element(:css, 'div#tab4_gainers_loosers')}
  slow_scroll(tb)
  view_all = tb.find_element(:css, 'img')
  view_all.click

  table = @wait.until{ @driver.find_element(:css, 'table#equityStockTable')}
  slow_scroll(table)
  select_element = @wait.until{ @driver.find_element(id: 'equitieStockSelect')}
  slow_scroll(select_element)
  select_object = Selenium::WebDriver::Support::Select.new(select_element)
  select_object.select_by(:text, 'NIFTY ALPHA 50')

  sleep(3)
end

begin
  load_pre_open_market_to_csv
  user_scenary
ensure
  @driver.quit
end
