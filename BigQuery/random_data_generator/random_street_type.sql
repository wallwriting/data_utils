/*creates a randomly select street type. The weights are arbitrary*/
CREATE FUNCTION test.random_street_type() AS
(
    (
        SELECT
            CASE
                WHEN num1 BETWEEN 	1	AND 	2500	THEN 	'St'	--Street
                WHEN num1 BETWEEN 	2501	AND 	5000	THEN 	'Rd'	--Road
                WHEN num1 BETWEEN 	5001	AND 	7500	THEN 	'Ave'	--Avenue
                WHEN num1 BETWEEN 	7501	AND 	7600	THEN 	'Brg'	--Bridge
                WHEN num1 BETWEEN 	7601	AND 	7700	THEN 	'Aly'	--Alley or Allée
                WHEN num1 BETWEEN 	7701	AND 	7800	THEN 	'Cmns'	--Commons
                WHEN num1 BETWEEN 	7801	AND 	7900	THEN 	'Cor'	--Corner
                WHEN num1 BETWEEN 	7901	AND 	8000	THEN 	'Trwy'	--Throughway
                WHEN num1 BETWEEN 	8001	AND 	8100	THEN 	'Tpke'	--Turnpike
                WHEN num1 BETWEEN 	8101	AND 	8200	THEN 	'Pkwy'	--Parkway
                WHEN num1 BETWEEN 	8201	AND 	8300	THEN 	'Ct'	--Court
                WHEN num1 BETWEEN 	8301	AND 	8400	THEN 	'Blvd'	--Boulevard
                WHEN num1 BETWEEN 	8401	AND 	8500	THEN 	'Est'	--Estate
                WHEN num1 BETWEEN 	8501	AND 	8600	THEN 	'Ests'	--Estates
                WHEN num1 BETWEEN 	8601	AND 	8700	THEN 	'Plz'	--Plaza
                WHEN num1 BETWEEN 	8701	AND 	8800	THEN 	'Sq'	--Square
                WHEN num1 BETWEEN 	8801	AND 	8900	THEN 	'Ter'	--Terrace or Terrasse
                WHEN num1 BETWEEN 	8901	AND 	9000	THEN 	'Fwy'	--Freeway
                WHEN num1 BETWEEN 	9001	AND 	9100	THEN 	'Gdn'	--Garden
                WHEN num1 BETWEEN 	9101	AND 	9200	THEN 	'Gdns'	--Gardens
                WHEN num1 BETWEEN 	9201	AND 	9300	THEN 	'Tunl'	--Tunnel
                WHEN num1 BETWEEN 	9301	AND 	9400	THEN 	'Jct'	--Junction
                WHEN num1 BETWEEN 	9401	AND 	9500	THEN 	'Dr'	--Drive
                WHEN num1 BETWEEN 	9501	AND 	9511	THEN 	'Expy'	--Expressway
                WHEN num1 BETWEEN 	9512	AND 	9522	THEN 	'Cir'	--Circle
                WHEN num1 BETWEEN 	9523	AND 	9533	THEN 	'Way'	--Way
                WHEN num1 BETWEEN 	9534	AND 	9544	THEN 	'Row'	--Row
                WHEN num1 BETWEEN 	9545	AND 	9555	THEN 	'Hwy'	--Highway
                WHEN num1 BETWEEN 	9556	AND 	9566	THEN 	'Ctr'	--Centre
                WHEN num1 BETWEEN 	9567	AND 	9577	THEN 	'Xing'	--Crossing
                WHEN num1 BETWEEN 	9578	AND 	9588	THEN 	'Cors'	--Corners
                WHEN num1 BETWEEN 	9589	AND 	9598	THEN 	'Anx'	--Annex or Anex
                WHEN num1 BETWEEN 	9599	AND 	9608	THEN 	'Loop'	--Loop
                WHEN num1 BETWEEN 	9609	AND 	9618	THEN 	'Mall'	--Mall
                WHEN num1 BETWEEN 	9619	AND 	9628	THEN 	'Mnrs'	--Manor
                WHEN num1 BETWEEN 	9629	AND 	9638	THEN 	'Mnrs'	--Manors
                WHEN num1 BETWEEN 	9639	AND 	9648	THEN 	'Mdw'	--Meadow
                WHEN num1 BETWEEN 	9649	AND 	9658	THEN 	'Mdws'	--Meadows
                WHEN num1 BETWEEN 	9659	AND 	9668	THEN 	'Cswy'	--Causeway
                WHEN num1 BETWEEN 	9669	AND 	9678	THEN 	'Ctrs'	--Centres
                WHEN num1 BETWEEN 	9679	AND 	9688	THEN 	'Cirs'	--Circles
                WHEN num1 BETWEEN 	9689	AND 	9698	THEN 	'Cmn'	--Common
                WHEN num1 BETWEEN 	9699	AND 	9708	THEN 	'Crse'	--Course
                WHEN num1 BETWEEN 	9709	AND 	9718	THEN 	'Cts'	--Courts
                WHEN num1 BETWEEN 	9719	AND 	9728	THEN 	'Cv'	--Cove
                WHEN num1 BETWEEN 	9729	AND 	9738	THEN 	'Cvs'	--Coves
                WHEN num1 BETWEEN 	9739	AND 	9748	THEN 	'Glns'	--Glen
                WHEN num1 BETWEEN 	9749	AND 	9758	THEN 	'Glns'	--Glens
                WHEN num1 BETWEEN 	9759	AND 	9768	THEN 	'Grn'	--Green
                WHEN num1 BETWEEN 	9769	AND 	9778	THEN 	'Grns'	--Greens
                WHEN num1 BETWEEN 	9779	AND 	9788	THEN 	'Mtwy'	--Motorway
                WHEN num1 BETWEEN 	9789	AND 	9798	THEN 	'Bch'	--Beach
                WHEN num1 BETWEEN 	9799	AND 	9808	THEN 	'Arc'	--Arcade
                WHEN num1 BETWEEN 	9809	AND 	9818	THEN 	'Blf'	--Bluff
                WHEN num1 BETWEEN 	9819	AND 	9828	THEN 	'Blfs'	--Bluffs
                WHEN num1 BETWEEN 	9829	AND 	9838	THEN 	'Brk'	--Brook
                WHEN num1 BETWEEN 	9839	AND 	9848	THEN 	'Clf'	--Cliff
                WHEN num1 BETWEEN 	9849	AND 	9858	THEN 	'Gtwy'	--Gateway
                WHEN num1 BETWEEN 	9859	AND 	9859	THEN 	'Byp'	--By-pass or Bypass
                WHEN num1 BETWEEN 	9860	AND 	9860	THEN 	'Vis'	--Vista
                WHEN num1 BETWEEN 	9861	AND 	9861	THEN 	'Byu'	--Bayou
                WHEN num1 BETWEEN 	9862	AND 	9862	THEN 	'Bnd'	--Bend
                WHEN num1 BETWEEN 	9863	AND 	9863	THEN 	'Btm'	--Bottom
                WHEN num1 BETWEEN 	9864	AND 	9864	THEN 	'Br'	--Branch
                WHEN num1 BETWEEN 	9865	AND 	9865	THEN 	'Brks'	--Brooks
                WHEN num1 BETWEEN 	9866	AND 	9866	THEN 	'Bg'	--Burg
                WHEN num1 BETWEEN 	9867	AND 	9867	THEN 	'Bgs'	--Burgs
                WHEN num1 BETWEEN 	9868	AND 	9868	THEN 	'Cp'	--Camp
                WHEN num1 BETWEEN 	9869	AND 	9869	THEN 	'Cyn'	--Canyon
                WHEN num1 BETWEEN 	9870	AND 	9870	THEN 	'Cpe'	--Cape
                WHEN num1 BETWEEN 	9871	AND 	9871	THEN 	'Clfs'	--Cliffs
                WHEN num1 BETWEEN 	9872	AND 	9872	THEN 	'Clb'	--Club
                WHEN num1 BETWEEN 	9873	AND 	9873	THEN 	'Crk'	--Creek
                WHEN num1 BETWEEN 	9874	AND 	9874	THEN 	'Cres'	--Crescent
                WHEN num1 BETWEEN 	9875	AND 	9875	THEN 	'Crst'	--Crest
                WHEN num1 BETWEEN 	9876	AND 	9876	THEN 	'Xrd'	--Crossroad
                WHEN num1 BETWEEN 	9877	AND 	9877	THEN 	'Xrds'	--Crossroads
                WHEN num1 BETWEEN 	9878	AND 	9878	THEN 	'Curv'	--Curve
                WHEN num1 BETWEEN 	9879	AND 	9879	THEN 	'Dl'	--Dale
                WHEN num1 BETWEEN 	9880	AND 	9880	THEN 	'Dm'	--Dam
                WHEN num1 BETWEEN 	9881	AND 	9881	THEN 	'Dv'	--Divide
                WHEN num1 BETWEEN 	9882	AND 	9882	THEN 	'Ext'	--Extension
                WHEN num1 BETWEEN 	9883	AND 	9883	THEN 	'Exts'	--Extensions
                WHEN num1 BETWEEN 	9884	AND 	9884	THEN 	'Fall'	--Fall
                WHEN num1 BETWEEN 	9885	AND 	9885	THEN 	'Fls'	--Falls
                WHEN num1 BETWEEN 	9886	AND 	9886	THEN 	'Fry'	--Ferry
                WHEN num1 BETWEEN 	9887	AND 	9887	THEN 	'Fld'	--Field
                WHEN num1 BETWEEN 	9888	AND 	9888	THEN 	'Flds'	--Fields
                WHEN num1 BETWEEN 	9889	AND 	9889	THEN 	'Flt'	--Flat
                WHEN num1 BETWEEN 	9890	AND 	9890	THEN 	'Flts'	--Flats
                WHEN num1 BETWEEN 	9891	AND 	9891	THEN 	'Frd'	--Ford
                WHEN num1 BETWEEN 	9892	AND 	9892	THEN 	'Frds'	--Fords
                WHEN num1 BETWEEN 	9893	AND 	9893	THEN 	'Frst'	--Forest
                WHEN num1 BETWEEN 	9894	AND 	9894	THEN 	'Frg'	--Forge
                WHEN num1 BETWEEN 	9895	AND 	9895	THEN 	'Frgs'	--Forges
                WHEN num1 BETWEEN 	9896	AND 	9896	THEN 	'Frk'	--Fork
                WHEN num1 BETWEEN 	9897	AND 	9897	THEN 	'Frks'	--Forks
                WHEN num1 BETWEEN 	9898	AND 	9898	THEN 	'Ft'	--Fort
                WHEN num1 BETWEEN 	9899	AND 	9899	THEN 	'Grvs'	--Groves
                WHEN num1 BETWEEN 	9900	AND 	9900	THEN 	'Hbr'	--Harbour
                WHEN num1 BETWEEN 	9901	AND 	9901	THEN 	'Hbrs'	--Harbours
                WHEN num1 BETWEEN 	9902	AND 	9902	THEN 	'Hvn'	--Haven
                WHEN num1 BETWEEN 	9903	AND 	9903	THEN 	'Hts'	--Heights
                WHEN num1 BETWEEN 	9904	AND 	9904	THEN 	'Hl'	--Hill
                WHEN num1 BETWEEN 	9905	AND 	9905	THEN 	'Hls'	--Hills
                WHEN num1 BETWEEN 	9906	AND 	9906	THEN 	'Holw'	--Hollow
                WHEN num1 BETWEEN 	9907	AND 	9907	THEN 	'Inlt'	--Inlet
                WHEN num1 BETWEEN 	9908	AND 	9908	THEN 	'Is'	--Island
                WHEN num1 BETWEEN 	9909	AND 	9909	THEN 	'Iss'	--Islands
                WHEN num1 BETWEEN 	9910	AND 	9910	THEN 	'Isle'	--Isle
                WHEN num1 BETWEEN 	9911	AND 	9911	THEN 	'Jcts'	--Junctions
                WHEN num1 BETWEEN 	9912	AND 	9912	THEN 	'Ky'	--Key
                WHEN num1 BETWEEN 	9913	AND 	9913	THEN 	'Kys'	--Keys
                WHEN num1 BETWEEN 	9914	AND 	9914	THEN 	'Knl'	--Knoll
                WHEN num1 BETWEEN 	9915	AND 	9915	THEN 	'Knls'	--Knolls
                WHEN num1 BETWEEN 	9916	AND 	9916	THEN 	'Lk'	--Lake
                WHEN num1 BETWEEN 	9917	AND 	9917	THEN 	'Lks'	--Lakes
                WHEN num1 BETWEEN 	9918	AND 	9918	THEN 	'Land'	--Land
                WHEN num1 BETWEEN 	9919	AND 	9919	THEN 	'Lndg'	--Landing
                WHEN num1 BETWEEN 	9920	AND 	9920	THEN 	'Ln'	--Lane
                WHEN num1 BETWEEN 	9921	AND 	9921	THEN 	'Lgt'	--Light
                WHEN num1 BETWEEN 	9922	AND 	9922	THEN 	'Lgts'	--Lights
                WHEN num1 BETWEEN 	9923	AND 	9923	THEN 	'Lf'	--Loaf
                WHEN num1 BETWEEN 	9924	AND 	9924	THEN 	'Lck'	--Lock
                WHEN num1 BETWEEN 	9925	AND 	9925	THEN 	'Lcks'	--Locks
                WHEN num1 BETWEEN 	9926	AND 	9926	THEN 	'Ldg'	--Lodge
                WHEN num1 BETWEEN 	9927	AND 	9927	THEN 	'Mews'	--Mews
                WHEN num1 BETWEEN 	9928	AND 	9928	THEN 	'Ml'	--Mill
                WHEN num1 BETWEEN 	9929	AND 	9929	THEN 	'Mls'	--Mills
                WHEN num1 BETWEEN 	9930	AND 	9930	THEN 	'Msn'	--Mission
                WHEN num1 BETWEEN 	9931	AND 	9931	THEN 	'Mt'	--Mount
                WHEN num1 BETWEEN 	9932	AND 	9932	THEN 	'Mtn'	--Mountain
                WHEN num1 BETWEEN 	9933	AND 	9933	THEN 	'Mtns'	--Mountains
                WHEN num1 BETWEEN 	9934	AND 	9934	THEN 	'Nck'	--Neck
                WHEN num1 BETWEEN 	9935	AND 	9935	THEN 	'Nene'	--Nene
                WHEN num1 BETWEEN 	9936	AND 	9936	THEN 	'Orch'	--Orchard
                WHEN num1 BETWEEN 	9937	AND 	9937	THEN 	'Oval'	--Oval
                WHEN num1 BETWEEN 	9938	AND 	9938	THEN 	'Opas'	--Overpass
                WHEN num1 BETWEEN 	9939	AND 	9939	THEN 	'Park'	--Park or Parc
                WHEN num1 BETWEEN 	9940	AND 	9940	THEN 	'Pass'	--Pass
                WHEN num1 BETWEEN 	9941	AND 	9941	THEN 	'Psge'	--Passage
                WHEN num1 BETWEEN 	9942	AND 	9942	THEN 	'Path'	--Path
                WHEN num1 BETWEEN 	9943	AND 	9943	THEN 	'Pike'	--Pike
                WHEN num1 BETWEEN 	9944	AND 	9944	THEN 	'Pine'	--Pine
                WHEN num1 BETWEEN 	9945	AND 	9945	THEN 	'Pnes'	--Pines
                WHEN num1 BETWEEN 	9946	AND 	9946	THEN 	'Pl'	--Place
                WHEN num1 BETWEEN 	9947	AND 	9947	THEN 	'Pln'	--Plain
                WHEN num1 BETWEEN 	9948	AND 	9948	THEN 	'Plns'	--Plains
                WHEN num1 BETWEEN 	9949	AND 	9949	THEN 	'Pt'	--Point or Pointe
                WHEN num1 BETWEEN 	9950	AND 	9950	THEN 	'Prt'	--Port
                WHEN num1 BETWEEN 	9951	AND 	9951	THEN 	'Pr'	--Prairie
                WHEN num1 BETWEEN 	9952	AND 	9952	THEN 	'Radl'	--Radial
                WHEN num1 BETWEEN 	9953	AND 	9953	THEN 	'Ramp'	--Ramp
                WHEN num1 BETWEEN 	9954	AND 	9954	THEN 	'Rnch'	--Ranch
                WHEN num1 BETWEEN 	9955	AND 	9955	THEN 	'Rpd'	--Rapid
                WHEN num1 BETWEEN 	9956	AND 	9956	THEN 	'Rpds'	-- Rapids
                WHEN num1 BETWEEN 	9957	AND 	9957	THEN 	'Rst'	--Rest
                WHEN num1 BETWEEN 	9958	AND 	9958	THEN 	'Rdg'	--Ridge
                WHEN num1 BETWEEN 	9959	AND 	9959	THEN 	'Rdgs'	--Ridges
                WHEN num1 BETWEEN 	9960	AND 	9960	THEN 	'Riv'	--River
                WHEN num1 BETWEEN 	9961	AND 	9961	THEN 	'Rte'	--Route
                WHEN num1 BETWEEN 	9962	AND 	9962	THEN 	'Rue'	--Rue
                WHEN num1 BETWEEN 	9963	AND 	9963	THEN 	'Run'	--Run
                WHEN num1 BETWEEN 	9964	AND 	9964	THEN 	'Shls'	--Shoal
                WHEN num1 BETWEEN 	9965	AND 	9965	THEN 	'Shls'	--Shoals
                WHEN num1 BETWEEN 	9966	AND 	9966	THEN 	'Shr'	--Shore
                WHEN num1 BETWEEN 	9967	AND 	9967	THEN 	'Shrs'	--Shores
                WHEN num1 BETWEEN 	9968	AND 	9968	THEN 	'Skwy'	--Skyway
                WHEN num1 BETWEEN 	9969	AND 	9969	THEN 	'Spg'	--Spring
                WHEN num1 BETWEEN 	9970	AND 	9970	THEN 	'Spgs'	--Springs
                WHEN num1 BETWEEN 	9971	AND 	9971	THEN 	'Spur'	--Spur
                WHEN num1 BETWEEN 	9972	AND 	9972	THEN 	'Sqs'	--Squares
                WHEN num1 BETWEEN 	9973	AND 	9973	THEN 	'Sta'	--Station
                WHEN num1 BETWEEN 	9974	AND 	9974	THEN 	'Stra'	--Stravenue
                WHEN num1 BETWEEN 	9975	AND 	9975	THEN 	'Strm'	--Stream
                WHEN num1 BETWEEN 	9976	AND 	9976	THEN 	'Sts'	--Streets
                WHEN num1 BETWEEN 	9977	AND 	9977	THEN 	'Smt'	--Summit or Summits
                WHEN num1 BETWEEN 	9978	AND 	9978	THEN 	'Trlr'	--Tailer
                WHEN num1 BETWEEN 	9979	AND 	9979	THEN 	'Trwy'	--Throughway
                WHEN num1 BETWEEN 	9980	AND 	9980	THEN 	'Trce'	--Trace
                WHEN num1 BETWEEN 	9981	AND 	9981	THEN 	'Trak'	--Track
                WHEN num1 BETWEEN 	9982	AND 	9982	THEN 	'Trfy'	--Trafficway
                WHEN num1 BETWEEN 	9983	AND 	9983	THEN 	'Trl'	--Trail
                WHEN num1 BETWEEN 	9984	AND 	9984	THEN 	'Upas'	--Underpass
                WHEN num1 BETWEEN 	9985	AND 	9985	THEN 	'Un'	--Union
                WHEN num1 BETWEEN 	9986	AND 	9986	THEN 	'Uns'	--Unions
                WHEN num1 BETWEEN 	9987	AND 	9987	THEN 	'Vly'	--Valley
                WHEN num1 BETWEEN 	9988	AND 	9988	THEN 	'Vlys'	--Valleys
                WHEN num1 BETWEEN 	9989	AND 	9989	THEN 	'Via'	--Via or Viaduct
                WHEN num1 BETWEEN 	9990	AND 	9990	THEN 	'Vw'	--View
                WHEN num1 BETWEEN 	9991	AND 	9991	THEN 	'Vws'	--Views
                WHEN num1 BETWEEN 	9992	AND 	9992	THEN 	'Vlg'	--Villa
                WHEN num1 BETWEEN 	9993	AND 	9993	THEN 	'Vlgs'	--Villas
                WHEN num1 BETWEEN 	9994	AND 	9994	THEN 	'Vl'	--Ville
                WHEN num1 BETWEEN 	9995	AND 	9995	THEN 	'Walk'	--Walk or Walkway
                WHEN num1 BETWEEN 	9996	AND 	9996	THEN 	'Wall'	--Wall
                WHEN num1 BETWEEN 	9997	AND 	9997	THEN 	'Ways'	--Ways
                WHEN num1 BETWEEN 	9998	AND 	9998	THEN 	'Wl'	--Well
                WHEN num1 BETWEEN 	9999	AND 	9999	THEN 	'Wls'	--Wells
                WHEN num1 BETWEEN 	10000	AND 	10000	THEN 	'Grv'	--Grove
            END
        FROM
            (
                SELECT 
                    CAST(rand() * (10000 - 1) + 1 as int64) as num1,
            )
    )
)
