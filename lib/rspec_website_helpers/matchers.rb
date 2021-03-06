require 'open3'
require 'addressable/uri'
require 'faraday'
require 'rspec/expectations'

RSpec::Matchers.define :pass_fragments_check do |properties|
  match do |path|
    @fragment_path = path
    $logger.debug path
    visit path
    if current_path =~ /\/$/ or current_path =~ /html$/
      properties.fragments.each do |fragment|
        unless fragment =~ /^n\d+$/
          @fragment= fragment
          $logger.info "FRAGMENT #{fragment} in #{path}"
          page.all("##{fragment}").count == 1
        end
      end
    else
      true
    end
  end
  failure_message do |path|
    "Expected that fragment '##{@fragment}' would be found on '#{@fragment_path}' but it was not"
  end
end


RSpec::Matchers.define :pass_spellcheck do |properties|
  match do |path|
    visit path
    $logger.info "SPELLCHECKING visit #{path}"
    if current_path =~ /\/$/ or current_path =~ /html$/
      $logger.info "SPELLCHECKING: #{path}"
      stdin, stdout, stderr, wait_thr= Open3.popen3("hunspell -d #{HUNSPELL_BASE_DICTIONARIES} -p #{HUNSPELL_DICTIONARY_FILE}  -l")
      page.evaluate_script('$("code").remove()')
      page.evaluate_script('$("pre").remove()')
      page.evaluate_script('$("sup").remove()')
      @text = page.text
      stdin.print @text
      stdin.close
      @res = stdout.read
      if @res.blank?
        true
      else
        $logger.warn "Spell check error #{@res.squish} in #{path.squish}, text: #{@text.squish}."
        false
      end
    else
      true
    end
  end
  failure_message do |path|
    "Expected that #{path} would pass the spellcheck. However, it contains:\n  #{@res} \n in its text: \n#{@text}"
  end
end


RSpec::Matchers.define :pass_existence_check do |properties|
  match do |path|
    $logger.info "PASS_EXISTENCE_CHECK #{path}"
    @uri = Addressable::URI.parse(Capybara.app_host) + Addressable::URI.parse(path)
    @resp= Faraday.new().get(@uri)
    if (200..299).include? @resp.status
      true
    else
      $logger.warn "path existence error #{@resp.status} for #{@uri}"
      false
    end
  end
  failure_message do |path|
    "Expected that getting #{path} would be OK, but it returns #{@resp.status}"
  end
end


RSpec::Matchers.define :be_an_existing_uri do
  match do |uri|
    if uri.scheme =~ /^http/
      $logger.info "GET check #{uri}"
      @resp= Faraday.new(ssl: {verify: false}).get(uri)
      if (200..399).include? @resp.status
        true
      else
        $logger.warn "path existence error #{@resp.status} for #{uri}"
        false
      end
    else
      true
    end
  end
  failure_message do |uri|
    "Expected that getting #{uri} would be OK, but it returns #{@resp.status}"
  end
end
