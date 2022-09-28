describe 'Test against XSS vulnerabilities', xss: true do
  describe 'on "Blabber" page', xss: true do
    before :all do
      on(BlabberPage).navigate_to_url 'https://xss-doc.appspot.com/demo/1'
    end

    it 'with naughty strings', tms: 'xss1' do
      payloads = on(BlabberPage).post_content :naughty_strings

      expect(payloads).to be_empty
    end

    it 'with payloads from constant', tms: 'xss2' do
      payloads = on(BlabberPage).post_content :payloads_from_constant

      expect(payloads).to be_empty
    end

    it 'with payloads from file', tms: 'xss3' do
      payloads = on(BlabberPage).post_content :payloads

      expect(payloads).to be_empty
    end
  end

  describe 'on "FourOrFour" page', xss: true do
    before :all do
      on(FourOrFourPage).navigate_to_url 'https://xss-game.appspot.com/level1/frame'
    end

    it 'with payloads from constant', tms: 'xss4' do
      pending 'Fix XSS vulnerabilities'
      payloads = on(FourOrFourPage).enter_query :payloads_from_constant

      expect(payloads).to be_empty
    end

    it 'with payloads from file', tms: 'xss5' do
      payloads = on(FourOrFourPage).enter_query :payloads

      expect(payloads).to be_empty
    end
  end

  describe 'on "Bobazillion" page', xss: true do
    before :all do
      on(FourOrFourPage).navigate_to_url 'https://xss-doc.appspot.com/demo/2'
    end

    it 'with payloads from constant', tms: 'xss6' do
      payloads = on(FourOrFourPage).enter_query :payloads_from_constant

      expect(payloads).to be_empty
    end

    it 'with payloads from file', tms: 'xss7' do
      payloads = on(FourOrFourPage).enter_query :payloads

      expect(payloads).to be_empty
    end
  end
end
