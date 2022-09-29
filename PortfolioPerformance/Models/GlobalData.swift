
import Foundation

/* { API Response example
 "data": {
 "active_cryptocurrencies": 13473,
 "upcoming_icos": 0,
 "ongoing_icos": 49,
 "ended_icos": 3376,
 "markets": 779,
 "total_market_cap": {
 "btc": 47262356.967886925,
 "eth": 656269899.744233,
 "ltc": 17276348218.846024,
 "bch": 5998210207.391161,
 "bnb": 5143253039.695361,
 "eos": 772181601232.1532,
 "xrp": 2573790634939.261,
 "xlm": 9533000159759.629,
 "link": 132322912349.41791,
 "dot": 99713063999.8808,
 "yfi": 98835806.02723579,
 "usd": 2245427755426.5947,
 "aed": 8247467372820.658,
 "ars": 248522877392431.8,
 "aud": 2993700836928.22,
 "bdt": 193875673074983.75,
 "bhd": 846602608339.5107,
 "bmd": 2245427755426.5947,
 "brl": 10700585968485.434,
 "cad": 2802978694237.7974,
 "chf": 2101349883499.6465,
 "clp": 1748245141820039.2,
 "cny": 14300904831536.422,
 "czk": 49751942776986.94,
 "dkk": 15109764044734.977,
 "eur": 2031416036056.885,
 "gbp": 1713602682409.3164,
 "hkd": 17576775101922.607,
 "huf": 753940781417091.5,
 "idr": 32200653794291524,
 "ils": 7221497749949.916,
 "inr": 170624558327721.47,
 "jpy": 277388917766624.22,
 "krw": 2733407844891406.5,
 "kwd": 683568835301.2517,
 "lkr": 640786799075929.1,
 "mmk": 3998844883058247,
 "mxn": 44993364914854.37,
 "myr": 9461109847489.953,
 "ngn": 934815151600539.8,
 "nok": 19365029275488.844,
 "nzd": 3256022934455.9307,
 "php": 116838585580439.9,
 "pkr": 410339482634445.25,
 "pln": 9502212402553.062,
 "rub": 198720327164692.72,
 "sar": 8423423582591.411,
 "sek": 21045471480805.977,
 "sgd": 3053478614633.1885,
 "thb": 75524091327804.61,
 "try": 33297897270772.07,
 "twd": 64632837106894.89,
 "uah": 66385573104225.484,
 "vef": 224834681150.865,
 "vnd": 51347319197217624,
 "zar": 32837360038134.074,
 "xdr": 1614224540809.6467,
 "xag": 91127519400.85345,
 "xau": 1172450102.495996,
 "bits": 47262356967886.92,
 "sats": 4726235696788692
 },
 "total_volume": {
 "btc": 2670289.0735473037,
 "eth": 37078775.90141608,
 "ltc": 976101211.1801486,
 "bch": 338894549.59936655,
 "bnb": 290590086.39199317,
 "eos": 43627703416.60065,
 "xrp": 145417314137.47485,
 "xlm": 538607631905.1795,
 "link": 7476149089.785987,
 "dot": 5633716182.832791,
 "yfi": 5584151.740233623,
 "usd": 126865048326.50455,
 "aed": 465975956828.49274,
 "ars": 14041363287879.574,
 "aud": 169141937625.97394,
 "bdt": 10953835666522.506,
 "bhd": 47832436630.73531,
 "bmd": 126865048326.50455,
 "brl": 604575387799.9572,
 "cad": 158366274151.21738,
 "chf": 118724752500.63432,
 "clp": 98774589326049.97,
 "cny": 807990806286.6738,
 "czk": 2810948875770.3545,
 "dkk": 853690768320.0895,
 "eur": 114773540570.50534,
 "gbp": 96817315360.46858,
 "hkd": 993075113345.5518,
 "huf": 42597110256005.64,
 "idr": 1819313709775412.8,
 "ils": 408009413272.38794,
 "inr": 9640164456692.768,
 "jpy": 15672273745014.729,
 "krw": 154435571351665.94,
 "kwd": 38621146066.89278,
 "lkr": 36203991883189.97,
 "mmk": 225931851119832,
 "mxn": 2542092659405.3833,
 "myr": 534545881123.7267,
 "ngn": 52816381688316.64,
 "nok": 1094110184102.6836,
 "nzd": 183962946896.71774,
 "php": 6601295797756.302,
 "pkr": 23183884749300.984,
 "pln": 536868145833.3448,
 "rub": 11227555127650.018,
 "sar": 475917355745.4551,
 "sek": 1189053956429.464,
 "sgd": 172519338942.52222,
 "thb": 4267056676823.2407,
 "try": 1881307174643.4019,
 "twd": 3651708670309.6875,
 "uah": 3750736989732.373,
 "vef": 12702997288.932903,
 "vnd": 2901086492606340.5,
 "zar": 1855287153231.6357,
 "xdr": 91202522051.63417,
 "xag": 5148639106.613061,
 "xau": 66242584.983684324,
 "bits": 2670289073547.3037,
 "sats": 267028907354730.38
 },
 "market_cap_percentage": {
 "btc": 40.1950436219418,
 "eth": 18.297732097306145,
 "usdt": 3.6301571945051987,
 "bnb": 3.2699767301349105,
 "usdc": 2.314306889190141,
 "xrp": 1.8745237507841142,
 "ada": 1.7312485832298823,
 "luna": 1.6294856504002635,
 "sol": 1.6101723887825004,
 "avax": 1.1088947959205917
 },
 "market_cap_change_percentage_24h_usd": 1.5427206300476188,
 "updated_at": 1648550522
 }
 } */

struct GlobalDataResponse: Codable {
    let data: GlobalData
}

struct GlobalData: Codable {
    
    let totalMarketCap, totalVolume, marketCapPercentage: [String: Double]
    let marketCapChangePercentage24HUsd: Double

    enum CodingKeys: String, CodingKey {
        
        case totalMarketCap = "total_market_cap"
        case totalVolume = "total_volume"
        case marketCapPercentage = "market_cap_percentage"
        case marketCapChangePercentage24HUsd = "market_cap_change_percentage_24h_usd"

    }
    
    static func calculateDominanceChange(todayDominance: Double, totalMarketCap: Double, totalMarketCapChange: Double, btcMarketCap: Double, btcMarketCapChange: Double) -> Double {
        
        var yesterdayTotalMarketCap: Double {
            totalMarketCap/(1 + totalMarketCapChange/100)
        }
        
        var yesterdayBtcMarketCap: Double {
            btcMarketCap - btcMarketCapChange
        }
        var yesterdayDominance: Double {
            (yesterdayBtcMarketCap/yesterdayTotalMarketCap) * 100
        }
        return todayDominance - yesterdayDominance
    }
}
