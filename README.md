# Powershell-Script-to-Force-Trigger-Software-updates-deployed-through-SCCM

Re-trigger software updates through SCCM baseline

Re-trigger failed software updates or status with "past due will be expired", "Waiting for install" and "pending verification". Refer "Steps to create configuration baseline.pdf" to configure the baseline in SCCM. This script will forcefully trigger the software installation until it reach it's 100% compliance.

You can also run remediation script on the impacted machine to achieve the compliance.
