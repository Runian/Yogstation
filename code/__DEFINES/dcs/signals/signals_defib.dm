/// Called when a defibrillator is first applied to someone. (mob/living/user, mob/living/target, harmful)
#define COMSIG_DEFIB_PADDLES_APPLIED "defib_paddles_applied"
	/// Defib is out of power.
	#define COMPONENT_BLOCK_DEFIB_DEAD (1<<0)
	/// Something else: we won't have a custom message for this and should let the defib handle it.
	#define COMPONENT_BLOCK_DEFIB_MISC (1<<1)
	/// If our safeties are on, turn them off for this shock.
	#define COMPONENT_DEFIB_BECOME_THE_DANGER (1<<2)
	/// If our safeties are off, turn them on for this shock.
	#define COMPONENT_DEFIB_BECOME_SAFE (1<<3)
/// Called when a defib has been successfully used, and a shock has been applied. (mob/living/user, mob/living/target, harmful, successful)
#define COMSIG_DEFIB_SHOCK_APPLIED "defib_zap"
/// Called when a defib is aborted and no shock was applied. (mob/living/user, mob/living/target, harmful)
#define COMSIG_DEFIB_ABORTED "defib_aborted"
/// Called when a defib's cooldown has run its course and it is once again ready. ()
#define COMSIG_DEFIB_READY "defib_ready"

