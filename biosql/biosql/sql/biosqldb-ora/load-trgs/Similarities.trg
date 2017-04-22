--
-- SQL script to create the trigger(s) enabling the load API for
-- SGLD_Similaritys.
--
-- Scaffold auto-generated by gen-api.pl.
--
--
-- $Id: Similarities.trg,v 1.1.1.2 2003-01-29 08:54:36 lapp Exp $
--

--
-- Copyright 2002-2003 Genomics Institute of the Novartis Research Foundation
-- Copyright 2002-2008 Hilmar Lapp
-- 
--  This file is part of BioSQL.
--
--  BioSQL is free software: you can redistribute it and/or modify it
--  under the terms of the GNU Lesser General Public License as
--  published by the Free Software Foundation, either version 3 of the
--  License, or (at your option) any later version.
--
--  BioSQL is distributed in the hope that it will be useful,
--  but WITHOUT ANY WARRANTY; without even the implied warranty of
--  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--  GNU Lesser General Public License for more details.
--
--  You should have received a copy of the GNU Lesser General Public License
--  along with BioSQL. If not, see <http://www.gnu.org/licenses/>.
--

CREATE OR REPLACE TRIGGER BIUR_Similaritys
       INSTEAD OF INSERT OR UPDATE
       ON SGLD_Similaritys
       REFERENCING NEW AS new OLD AS old
       FOR EACH ROW
DECLARE
	pk		SG_SIMILARITY.OID%TYPE DEFAULT :new.Sim_Oid;
	do_DML		INTEGER DEFAULT BSStd.DML_NO;
BEGIN
	IF INSERTING THEN
		do_DML := BSStd.DML_I;
	ELSE
		-- this is an update
		do_DML := BSStd.DML_UI;
	END IF;
	-- do insert or update (depending on whether it exists or not)
	pk := Sim.get_oid(
			Sim_OID => pk,
		        Sim_SCORE => Sim_SCORE,
			Sim_EXPECT_MANTISSA => Sim_EXPECT_MANTISSA,
			Sim_EXPECT_EXPONENT => Sim_EXPECT_EXPONENT,
			Sim_PCT_IDENTITY => Sim_PCT_IDENTITY,
			Sim_PCT_COVERAGE => Sim_PCT_COVERAGE,
			Sim_SRC_START_POS => Sim_SRC_START_POS,
			Sim_SRC_END_POS => Sim_SRC_END_POS,
			Sim_SRC_STRAND => Sim_SRC_STRAND,
			Sim_SRC_FRAME => Sim_SRC_FRAME,
			Sim_TGT_START_POS => Sim_TGT_START_POS,
			Sim_TGT_END_POS => Sim_TGT_END_POS,
			Sim_TGT_STRAND => Sim_TGT_STRAND,
			Sim_TGT_FRAME => Sim_TGT_FRAME,
			do_DML             => do_DML);
END;
/
