class Attachfile < ApplicationRecord
	mount_uploaders :filename, AttachmentUploader
	#serialize :avatars, JSON # If you use SQLite, add this line.
	
	def self.addfiles(_reportid, _params)
		attachfiles = _params[:attachment];
		if(nil == _params || nil == attachfiles)
			return
		end
		
		savefile = Attachfile.new
		savefile.reportid = _reportid
		savefile.filename = attachfiles
		savefile.created_at = DateTime.current.to_s(:db)
		savefile.updated_at = DateTime.current.to_s(:db)
		savefile.save!
		
=begin	
		attachfiles.each do |file|
			savefile = Attachfile.new(
			savefile.reportid = _reportid
			savefile.filename = file
			savefile.save!
			#uploader = AttachmentUploader.new(savefile)
			#uploader.store!(file)
		end
=end
	end

	def self.updatefiles(_reportid, _params)
		attachfiles = _params[:attachment];
		if(nil == _params || nil == attachfiles)
			return
		end
		
		savefile = Attachfile.find_by(reportid: _reportid)
		if(savefile)
			savefile.filename = attachfiles
			savefile.updated_at = DateTime.current.to_s(:db)
			savefile.save!
		else
			savefile = Attachfile.new
			savefile.reportid = _reportid
			savefile.filename = attachfiles
			savefile.created_at = DateTime.current.to_s(:db)
			savefile.updated_at = DateTime.current.to_s(:db)
			savefile.save!
		end
	end

	def self.deletefiles(_reportid)
		result = true
		begin
			transaction do
				Attachfile.where(reportid: _reportid).delete_all
			end
		rescue ActiveRecord::RecordInvalid => exception
			puts "Reportroom NewReport Error #{exception}"
			result = false
			Rollback
		end
		return result
	end
	
	def self.findfiles(_reportid)
		attachfiles = Attachfile.select(:id, :reportid, :filename).where(reportid: _reportid)		
		
		result = Hash.new
		imagefiles = Array.new
		videofiles = Array.new
		filelists = Array.new
		
		attachfiles.each do |info|
			info.filename.each do |file|
				if file.content_type.start_with? "image"
					imagefiles.push( file )
				elsif file.content_type.start_with? "video"
					videofiles.push( file )
				else
					filelists.push( file )
				end
			end
		end
		
		if imagefiles.present?
			result[:image] = imagefiles
		end
		
		if videofiles.present?
			result[:video] = videofiles
		end
		
		if filelists.present?
			result[:file] = filelists
		end
		
		return result
	end
end
