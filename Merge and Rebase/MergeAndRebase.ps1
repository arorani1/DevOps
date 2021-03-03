param(
	  [Parameter(Mandatory=$true)][string]$triggeredBranch,
	  [Parameter(Mandatory=$true)][string]$gitFolder
	  )

$global:dateTime = [DateTime]::UtcNow.ToString('u').Replace('Z',' UTC')

$global:developBranch = "Develop"

$global:feature1Branch = "feature/Feature1"
$global:feature2Branch = "feature/Feature2"
$global:feature3Branch = "feature/Feature3"
$global:releaseBranch = "release/Release"

$global:branchArray = @($feature1Branch,$feature2Branch,$feature3Branch,$releaseBranch)

function mergeIntoDevelop()
{
	git checkout $triggeredBranch
	#Checkout the Develop Branch
	git checkout $developBranch
	echo  "$global:dateTime Develop Branch Checked Out : $developBranch"
	#Merge the Triggered Branch into Develop Branch
	echo "--------------------------------------------------------------"
	echo "                  Merging BRANCH                              "
	echo "--------------------------------------------------------------"
	git merge $triggeredBranch
	
		pushMergeChanges

	
}

function pushMergeChanges()
{
	echo "--------------------------------------------------------------"
	echo "       		PUSH Changes To Remote Repository               "
	echo "--------------------------------------------------------------"

	git push origin $developBranch
	echo  "$global:dateTime Proceeding to rebaseWithDevelop"
	rebaseWithDevelop
}

function rebaseWithDevelop()
{
foreach($branch in $branchArray)
{
	echo "--------------------------------------------------------------"
	echo "                CHECKOUT $branch for REBASE                   "
	echo "--------------------------------------------------------------"
    git checkout $branch
	git rebase $developBranch
		pushRebaseChanges $branch

}
}

function pushRebaseChanges($branch)
{
	echo "--------------------------------------------------------------"
	echo "       Pushing Rebase Changes To Remote Repository            "
	echo "--------------------------------------------------------------"

	git push origin $branch
	echo "global:dateTime Abort Rebase will run in case of Merge Conflicts or Rebase Error"
	git rebase --abort
}

# main Function starts here
#----------------------------

#Navigate to the git folder in the node
Set-Location $gitFolder
echo "$global:dateTime Inside Directory : $gitFolder"

#Calling mergeIntoDevelop
mergeIntoDevelop
