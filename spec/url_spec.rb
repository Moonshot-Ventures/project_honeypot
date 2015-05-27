require "spec_helper"

describe ProjectHoneypot::Url do
  describe "with honeypot response" do
    let(:url) { ProjectHoneypot::Url.new("127.0.0.1", "127.1.63.3") }

    it "is safe" do
      expect(url.safe?).to be false

      expect(url.safe?(score: 63)).to be false
      expect(url.safe?(score: 64)).to be true

      expect(url.safe?(last_activity: 1)).to be false
      expect(url.safe?(last_activity: 2)).to be true

      expect(url.safe?(last_activity: 2, score: 64)).to be true
      expect(url.safe?(last_activity: 1, score: 64)).to be false
      expect(url.safe?(last_activity: 2, score: 63)).to be false

      expect(url.safe?(offenses: [:comment_spammer])).to be true
      expect(url.safe?(offenses: [:suspicious, :comment_spammer])).to be false
    end

    it "has the correct latest activity" do
      expect(url.last_activity).to eq(1)
    end

    it "has the correct score" do
      expect(url.score).to eq(63)
    end

    it "has the correct offenses" do
      expect(url.offenses).to include(:suspicious)
      expect(url.offenses).to include(:harvester)
      expect(url.offenses).to_not include(:comment_spammer)
      expect(url).to be_suspicious
      expect(url).to be_harvester
      expect(url).to_not be_comment_spammer
    end
  end

  describe "with search engine honeypot response" do
    subject { ProjectHoneypot::Url.new("127.0.0.1", "127.0.9.0") }
    it { should be_safe }
    it { should be_search_engine }
  end

  describe "with nil honeypot response" do
    subject { ProjectHoneypot::Url.new("127.0.0.1", nil) }
    it { should be_safe }
  end
end
