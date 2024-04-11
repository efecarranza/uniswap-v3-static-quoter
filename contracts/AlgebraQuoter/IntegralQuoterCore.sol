// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity =0.7.6;
pragma abicoder v2;

import "./interfaces/IIntegralPool.sol";
import "./interfaces/ITickLens.sol";
import "../UniV4likeQuoterCore.sol";

contract IntegralQuoterCore is UniV4likeQuoterCore {
    address immutable tickLens;

    constructor(address _tickLens) {
        tickLens = _tickLens;
    }

    function getPoolGlobalState(
        address pool
    ) internal view override returns (GlobalState memory gs) {
        (gs.startPrice, gs.startTick, gs.fee, , , ) = IIntegralPool(pool)
            .globalState();
    }

    function getTickSpacing(
        address pool
    ) internal view override returns (int24) {
        return IIntegralPool(pool).tickSpacing();
    }

    function getLiquidity(
        address pool
    ) internal view override returns (uint128) {
        return IIntegralPool(pool).liquidity();
    }

    function nextInitializedTick(
        address poolAddress,
        int24 tick,
        bool zeroForOne
    ) internal view override returns (int24 next, bool initialized) {
        ITickLens.PopulatedTick[2] memory ticks = ITickLens(tickLens)
            .getClosestActiveTicks(poolAddress, tick);

        if (zeroForOne) {
            return (ticks[1].tick, true);
        } else {
            return (ticks[0].tick, true);
        }
    }

    function getTicks(
        address pool,
        int24 tick
    )
        internal
        view
        override
        returns (
            uint128 liquidityTotal,
            int128 liquidityDelta,
            int24 prevTick,
            int24 nextTick,
            uint256 outerFeeGrowth0Token,
            uint256 outerFeeGrowth1Token
        )
    {
        return IIntegralPool(pool).ticks(tick);
    }
}
