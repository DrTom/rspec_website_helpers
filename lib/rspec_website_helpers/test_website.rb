shared_context :test_website do |start_path|

  before :all do
    collect_targets start_path
    $logger.debug internal_pages: @internal_pages
    $logger.debug external_uris: @external_uris
  end

  it "spellchecking", type: :feature do
    @internal_pages.each do |path,properties|
      expect(path).to pass_spellcheck(properties)
    end
  end

  it "has only existing href targets", type: :feature do
    @internal_pages.each do |path,properties|
      expect(path).to pass_existence_check(properties)
    end
  end

  it "fragment targets exist", type: :feature do
    @internal_pages.each do |path,properties|
      expect(path).to pass_fragments_check(properties)
    end
  end

  it "points only to existing external pages", type: :feature do
    @external_uris.each do |external_uri|
      expect(external_uri).to be_an_existing_uri
    end
  end

end

