#!/usr/bin/env ruby
require 'open-uri'
require 'nokogiri'
require 'pry'

class ParseHtml

	def initialize
		index_page = Nokogiri::HTML(open("/home/akarsale/Downloads/task-export-1485457064/tmp/task-export20170126-41886-cy5u04/index.html"))
		tablerows = index_page.css('tr')
		@files_to_parse = []
		@error_msgs = []
		parse_index(tablerows)
	end

	def parse_index(tablerows)
		tablerows.each do |tr|
			tabledatas = tr.children
			data_length = tabledatas.length
			if tabledatas[data_length - 1].children.text == "error"
				@files_to_parse << tabledatas[0].children[0].attributes["href"].value
			end
		end
		extract_error_msg
	end

	def extract_error_msg
		@files_to_parse.each do |file|
			begin
				task = Nokogiri::HTML(open("/home/akarsale/Downloads/task-export-1485457064/tmp/task-export20170126-41886-cy5u04/"+file))
				@error_msgs << task.xpath('//ul[@class="plan-step"]/li/div[@class="action"]/pre').last.children.first.text.split(/\n{2}|\n\/opt/)[0]
			rescue
				next
			end
		end
			@error_msgs.uniq.each do |error|
				p "==============================================="
				p error
				p "==============================================="
			end
	end
end

ParseHtml.new