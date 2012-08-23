require 'rubygems'
require 'watir-webdriver'
require 'csv'

client = Selenium::WebDriver::Remote::Http::Default.new
client.timeout = 180

@b = Watir::Browser.new :firefox, :http_client => client

@b.goto 'http://catalog.flatworldknowledge.com/signup'
@b.text_field(:name => 'username').set 'josh@studyegg.com'
@b.text_field(:name => 'login_password').set 'silver'
@b.element(:css => "#login-button a").click

CSV.open("Govt101.csv", "wb") do |csv|
  
  (13..17).each do |i|
    @b.goto "http://catalog.flatworldknowledge.com/bookhub/reader/3797?e=paletz_1.0-ch#{i.to_s.rjust(2, '0')}"
    if !@b.element(:css => "#study-aids-tab").exists?
      puts "Skipping chapter #{i}"
      next
    end

    @b.element(:css => "#study-aids-tab").click
    @b.element(:css => '#flip-it').wait_until_present
    @b.element(:css => "#quiz-tab").click
    @b.element(:id => 'q-number').wait_until_present


    begin 
      @b.element(:css => ".q-answer-choice").click
      @b.element(:id => "q-submit").click
      @b.element(:css => ".q-supplied-answer").wait_until_present

      question_num = /([0-9]+)/.match(@b.element(:css => "#q-text").text)[1]
      question = /[0-9]+: (.+)/.match(@b.element(:css => "#q-text").text)[1]
      answers = @b.element(:css => "#quiz-contents ul").text.split "\n"

      row = [i, question_num , question] + answers
      csv << row

      current = (/(^[0-9]+)/.match @b.element(:css => '#q-number').text)[1].to_i
      nnext = current + 1
      total = (/([0-9]+$)/.match @b.element(:css => '#q-number').text)[1].to_i
      break if nnext > total

      @b.element(:css => "#q-next-link a").click
      Watir::Wait.until { @b.text.include? "#{nnext} of #{total}" }
    end while @b.element(:css => "#q-next-link a")
  end
end

