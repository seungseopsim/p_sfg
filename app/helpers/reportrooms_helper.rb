module ReportroomsHelper
	
	# 수정 가능 시간 확인
	def vaildModify(_time)
		return (_time >= 0 && _time < $modifytime)
	end
	
	#수정 가능 여부
	def isShowModifyMenu(_report)
		if current_user['idx_ccu_id'] == _report['userid']
    		return vaildModify(_report['modify']) || isPUser
		else
			return isPUser
		end
	end
	
	def isModify(_report)
		if vaildModify(_report['modify'])
			return current_user['idx_ccu_id'] == _report['userid']
		end
		return false
	end
	
	def isDelete(_report)
		return current_user['idx_ccu_id'] == _report['userid'] || isPUser
	end
		
	def toTimeFormat(_type, _time)
		if _type == 1
			return _time.strftime("%H:%M")
		else
			return _time.strftime("%m-%d")
		end
	end
end
