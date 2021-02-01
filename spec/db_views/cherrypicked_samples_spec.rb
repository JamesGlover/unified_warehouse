# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'cherrypicked_samples_view' do
  # @note We use before_type_cast in a few places here, as the raw view SQL query doesn't cast its values.
  # This is a little useful for testing the uuids (although oddly we need to reload to get the correct behaviour)
  # but as the actual interface will be with the SQL directly, we don't actually care about the details of what
  # comes back from
  let(:sample1) { create(:sample, sanger_sample_id: 'MY_SANGER_SAMPLE_ID_1', uuid: '00000000-1111-2222-3333-888888888888') }
  let(:sample2) { create(:sample, sanger_sample_id: 'MY_SANGER_SAMPLE_ID_2', uuid: '00000000-1111-2222-3333-999999999999') }
  let(:results) do
    ApplicationRecord.connection.execute('SELECT * FROM cherrypicked_samples')
  end

  it 'lists finished activities at the role level' do
    expect(results.size).to eq 2
  end

  it 'has the expected columns' do
    expect(results.fields).to eq %w[
      wh_event_id event_uuid_bin event_uuid event_type occured_at user_identifier
      role_type subject_type subject_friendly_name subject_uuid subject_uuid_bin
    ]
  end
end
