-- BOLL 指标
-- @param list K线数组
-- @param getMethod 计算字段
-- @param param 12

function BOLLIndex(aryList, getMethod, param)

	funcMa = MA(getMethod, param, aryList)
	funcStd = STD(getMethod, param, aryList)
	aryBOLL = {}

	for i = 1, #aryList, 1 do

		mid = funcMa(i)
		tmp2 = funcStd(i)

		if (mid == "1.175494351e-38F" or tmp2 == "1.175494351e-38F") then

			aryBOLL[i] = {m = "1.175494351e-38F", t = "1.175494351e-38F", b = "1.175494351e-38F"}
		else

			m = mid
			t = mid + tmp2 * 2
			b = mid - tmp2 * 2
			aryBOLL[i] = {m = m, t = t, b = b}
		end
	end

	return aryBOLL
end
