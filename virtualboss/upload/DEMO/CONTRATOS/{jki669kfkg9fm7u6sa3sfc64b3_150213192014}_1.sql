		<tr class="tr_table">
			<td colspan="2" align="center">
				<div class="box_header" style="margin-top:3px;padding-top:5px;padding-bottom:5px;">
					<!-- BLOCO QUE CONTÉM A DESCRIÇÃO DO PAGAMENTO DO LANÇAMENTO -->
					<table cellpadding="0" cellspacing="0" width="100%" border="0">
						<tr>
							<!--<td width="10%" align="center" class="td_lcto"><?php echo(getTText("cod_lcto_ordinario",C_TOUPPER));?></td>-->
							<td width="18%" align="center" class="td_lcto"><?php echo(dDate(CFG_LANG,getValue($objRS,"dt_rec"),false));?></td>
							<td width="18%" align="right"  class="td_lcto" style="padding-right:5px;"><?php echo(getTText("vlr_pago",C_TOUPPER));?></td>

							<td width="18%" align="right"  class="td_lcto" style="padding-right:5px;"><?php /*echo(getTText("vlr_juros",C_TOUPPER));*/?></td>
							<td width="18%" align="right"  class="td_lcto" style="padding-right:5px;"><?php /*echo(getTText("vlr_desc",C_TOUPPER));*/?></td>
							
							<td width="18%" align="right"  class="td_lcto" style="padding-right:5px;"><?php echo(getTText("total_pg",C_TOUPPER));?></td>
						</tr>
						<tr>						   
							<!--<td width="10%" align="center" class="td_lcto_conteudo">&bull;&nbsp;<?php echo(getValue($objRS,"cod_lcto_ordinario"));?></td>-->
							<td width="18%" align="center" class="td_lcto_conteudo"><?php echo(dDate(CFG_LANG,getValue($objRS,"dt_rec"),false));?></td>
							<td width="18%" align="right"  class="td_lcto_conteudo" style="padding-right:5px;">
								<table cellpadding="0" cellspacing="0" width="100%" border="0">
									<tr>
										<td width="40%" align="right"><?php echo(getTText("reais_abrev",C_NONE));?></td>
										<td width="60%" align="right"><?php echo(number_format((double) getValue($objRS,"vlr_pago"),2,',','.'));?></td>
									</tr>
								</table>
							</td>
							<td width="18%" align="right"  class="td_lcto_conteudo" style="padding-right:5px;">
								<table cellpadding="0" cellspacing="0" width="100%" border="0">
									<tr>
										<!--
										<td width="40%" align="right"><?php echo(getTText("reais_abrev",C_NONE));?></td>
										<td width="60%" align="right"><?php echo(number_format((double) getValue($objRS,"vlr_juros"),2,',','.'));?></td>
										-->
									</tr>
								</table>
							</td>
							<td width="18%" align="right"  class="td_lcto_conteudo" style="padding-right:5px;">
								<table cellpadding="0" cellspacing="0" width="100%" border="0">
									<tr>
										<!--									
										<td width="40%" align="right"><?php echo(getTText("reais_abrev",C_NONE));?></td>
										<td width="60%" align="right"><?php echo(number_format((double) getValue($objRS,"vlr_desc"),2,',','.'));?></td>
										-->
									</tr>
								</table>
							</td>
							<td width="18%" align="right"  class="td_lcto_conteudo" style="padding-right:5px;">
								<table cellpadding="0" cellspacing="0" width="100%" border="0">
									<tr>
										<td width="40%" align="right"><?php echo(getTText("reais_abrev",C_NONE));?></td>
										<td width="60%" align="right">
											<?php
												$dblSubTotal = 0; 
												$dblSubTotal = getValue($objRS,"vlr_pago");// + getValue($objRS,"vlr_juros") - getValue($objRS,"vlr_desc");
												echo(number_format((double) $dblSubTotal,2,',','.'));
											?>
										</td>
									</tr>
								</table>
							</td>
						</tr>
					</table>
					<!-- BLOCO QUE CONTÉM A DESCRIÇÃO DO PAGAMENTO DO LANÇAMENTO -->
				</div>
			</td>
		</tr>