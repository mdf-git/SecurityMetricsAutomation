#!/bin/bash -e
# https://github.com/tradichel/SecurityMetricsAutomation/
# Org/stacks/OU/ou_functions.sh
# author: @teriradichel @2ndsightlab
# description: Functions for OU creation
##############################################################
source ../../../Functions/shared_functions.sh
source ../Organization/organization_functions.sh

profile="Org"

deploy_ou(){

  nameparam=$1
  parentid=$2

  func=${FUNCNAME[0]}
  validate_param 'nameparam' '$name' '$func'
  validate_param 'parentid' '$parentid' '$func'

  parameters=$(add_parameter "NameParam" $nameparam)
  parameters=$(add_parameter "ParentIdParam" $parentid $parameters)

  resourcetype='OU'
  template='cfn/OU.yaml'
  deploy_stack $profile $nameparam $resourcetype $template $parameters

}

deploy_root_ou(){
   profile="OrgRoot"
   root_ou_id=$(get_root_id)
   deploy_ou $1 $root_ou_id
}

get_root_Id(){
	rootid=$(aws organizations list-roots --query Roots[0].Id --output text --profile $profile)
	echo $rootid
}

get_ou_id_from_name(){
  ouname=$1

  func=${FUNCNAME[0]}
  validate_param "ouname" "$ouname" "$func"
	
	rootid=$(get_root_id)
	
  id=$(aws organizations list-organizational-units-for-parent --parent-id $rootid \
		--query 'OrganizationalUnits[?Name == `'$ouname'`].Id' --output text --profile $profile)
  echo $id
}

################################################################################
# Copyright Notice
# All Rights Reserved.
# All materials (the “Materials”) in this repository are protected by copyright 
# under U.S. Copyright laws and are the property of 2nd Sight Lab. They are provided 
# pursuant to a royalty free, perpetual license the person to whom they were presented 
# by 2nd Sight Lab and are solely for the training and education by 2nd Sight Lab.
#
# The Materials may not be copied, reproduced, distributed, offered for sale, published, 
# displayed, performed, modified, used to create derivative works, transmitted to 
# others, or used or exploited in any way, including, in whole or in part, as training 
# materials by or for any third party.
#
# The above copyright notice and this permission notice shall be included in all 
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, 
# INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A 
# PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT 
# HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION 
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE 
# SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
################################################################################  
