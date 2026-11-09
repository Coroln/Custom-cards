cosmetaUtil = cosmetaUtil or {}

cosmetaUtil.CosmetaATK = cosmetaUtil.CosmetaATK or {}

function cosmetaUtil.AddCosmetaATK(code,atk)
    cosmetaUtil.CosmetaATK[code] = atk
end

function cosmetaUtil.CosmetaATKExists(code)
    return cosmetaUtil.CosmetaATK[code] ~= nil
end

function cosmetaUtil.GetCosmetaATK(code)
    return cosmetaUtil.CosmetaATK[code]
end