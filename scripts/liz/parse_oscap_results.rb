#!/usr/bin/env ruby

#require 'nokogiri'
#
#doc = Nokogiri::XML(File.open('sec_results/ssg/el7-ssg-1529523264.xml'))
#
## because I'm lazy
#doc.remove_namespaces!
##
##rule_search_string = '_audit_rules_'
#rule_search_string = '_audit_'
## XPATH to attempt to get results for tests pertinent to audit rules
#result_nodes = doc.xpath("//rule-result[contains(@idref,'#{rule_search_string}')]")
#
#failed_tests = []
#passed_tests = []
#result_nodes.each do |rule_result|
#  result = rule_result.element_children.at('result')
#  if result.child.content == 'fail'
#    failed_tests << rule_result
#  elsif result.child.content == 'pass'
#    passed_tests << rule_result
#  else
#    # 'notselected', so do nothing
#  end
#end
#
#puts 'OSCAP RESULTS SUMMARY:'
#puts "#{failed_tests.size + passed_tests.size} Total Tests with 'idref' ~= #{rule_search_string}'"
#printf("%6d tests passed\n", passed_tests.size)
#printf("%6d tests failed\n", failed_tests.size)
#puts
#puts 'FAILED TESTS:'
#failed_tests.each do |rule_result|
#  puts '  ' + rule_result.attribute('idref').value
#end
#

def get_oscap_test_results(rule_search_string)
  require 'nokogiri'

  results_xml = Dir.glob('sec_results/ssg/el*-ssg-*.xml').sort!
  results_xml.sort!
  fail('Could not find results XML file in sec_results/ssg') if results_xml.empty?

  puts "Processing #{results_xml.last}"
  doc = Nokogiri::XML(File.open(results_xml.last))

  # because I'm lazy
  doc.remove_namespaces!

  # XPATH to get the pertinent test results:
  #   Any node named 'rule-result' for which the attribute 'idref'
  #   contains rule_search_string
  result_nodes = doc.xpath("//rule-result[contains(@idref,'#{rule_search_string}')]")

  failed_tests = []
  passed_tests = []
  result_nodes.each do |rule_result|
    # Results are recorded in a child node named 'result'.
    # Within the 'result' node, the actual result string is
    # the content of that node's (only) child node.
    result = rule_result.element_children.at('result')
    if result.child.content == 'fail'
      failed_tests << rule_result
    elsif result.child.content == 'pass'
      passed_tests << rule_result
    else
      # 'notselected', so do nothing
    end
  end
  { :rule_search_string => rule_search_string,
    :passed_tests       => passed_tests,
    :failed_tests       => failed_tests
  }
end

def print_test_results_summary(results)
  puts 'OSCAP RESULTS SUMMARY:'
  total = results[:failed_tests].size + results[:passed_tests].size
  puts "#{total} Total Tests with 'idref' ~= '#{results[:rule_search_string]}'"
  printf("%10d tests passed\n", results[:passed_tests].size)
  printf("%10d tests failed\n", results[:failed_tests].size)
  puts
  puts 'Failed Tests:'
  results[:failed_tests].each do |rule_result|
    puts '  ' + rule_result.attribute('idref').value
  end
end

if ARGV.empty?
  search_string = '_audit_'
else
  search_string = ARGV[0]
end
results = get_oscap_test_results(search_string)
print_test_results_summary(results)

