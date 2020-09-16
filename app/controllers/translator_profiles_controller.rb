class TranslatorProfilesController < ApplicationController
  def extract
    # empty
  end

  def verify
	begin
	  url = params[:profileurl]
	  pdp = ProfileDataProvider.new(url)

	  unless pdp.nil? or pdp.error?
        @data = pdp.get_data
      end
    ensure
      render 'save'
    end
  end

  def save
  	# a shortcut for less typing
  	pp = params[:profile]

  	pp[:lang1], pp[:lang2], pp[:lang3] = pp[:targetlangs].split(/,\s+/)[0..2]

  	reqparams = params.require(:profile).permit( pp.except('targetlangs').keys )
  	@profile  = Profile.new(reqparams)

  	@profile.save

  	@existing_profiles = Profile.all
  	#render plain: params[:profile]
  end
end
