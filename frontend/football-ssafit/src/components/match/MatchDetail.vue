<template>

    <div class="container mt-4">
        <!-- 상단 이미지 섹션 -->
        <div class="row">
            <div class="col-12">
                <img :src="store.match.image" alt="축구장 이미지" class="img-fluid rounded">
            </div>
        </div>

        <div class="row mt-4 h-100">
            <!-- 왼쪽 구장 정보 -->
            <div class="col-md-6 d-flex align-items-stretch">
                <div class="card flex-grow-1">
                    <div class="card-body">
                        <h5 class="card-title">구장 정보</h5>
                        <table class="table">
                            <thead>
                                <tr>
                                    <th>Source</th>
                                    <th>Info</th>
                                    <th>Charge</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td>8x8 축구 매치</td>
                                    <td>70×37m 실외 인조잔디</td>
                                    <td>110000</td>
                                </tr>
                                <tr>
                                    <td>A 구장</td>
                                    <td>37×20m 실외 인조잔디</td>
                                    <td>50000</td>
                                </tr>

                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

            <!-- 오른쪽 경기장 정보 -->
            <div class="col-md-6 d-flex align-items-stretch text-center">
                <div class="card flex-grow-1">
                    <div class="card-body">
                        <h4 class="card-title">{{ store.match.stadiumName }}</h4>
                        <p>{{ store.match.address }}</p>
                        <div class="tier" v-if="store.matchAvgTier">
                            <p>예상 평균 레벨은 <strong>{{ store.matchAvgTier }}</strong>입니다.</p>
                            <img :src="`/src/assets/${store.matchAvgTier}.webp`" alt="Tier Image" width="200px">
                        </div>
                        <p v-else>흠...</p>
                        
                    </div>
                </div>
            </div>

            <div class="match-guidelines mt-4">
                <div class="card">
                    <div class="card-header">
                        <h4>매치 진행 방식</h4>
                    </div>
                    <div class="card-body">
                        <!-- 매치 규칙 -->
                        <div>
                            <h5>매치 규칙</h5>
                            <ul>
                                <li>모든 파울은 사이드라인에서 킥인</li>
                                <li>골키퍼에게 백패스 가능 손으로는 잡으면 안 돼요</li>
                                <li>사람을 향한 태클 금지</li>
                            </ul>
                        </div>

                        <!-- 진행 방식 -->
                        <div>
                            <h5>진행 방식</h5>
                            <ul>
                                <li>풋살화와 개인 음료만 준비하세요</li>
                                <li>매니저가 경기 진행을 도와드려요</li>
                                <li>골키퍼와 휴식을 공평하게 돌아가면서 해요</li>
                                <li>레벨 데이터를 기준으로 팀을 나눠요</li>
                                <li>친구끼리 와도 팀 실력이 맞지 않으면 다른 팀이 될 수 있어요</li>
                            </ul>
                        </div>

                        <!-- 알아두면 좋아요 -->
                        <div>
                            <h5>알아두면 좋아요</h5>
                            <ul>
                                <li>서로 존중하고 격려하며 함께 즐겨요</li>
                                <li>매일 4,500여 명이 팀 없이도 풋살을 즐기고 있어요</li>
                            </ul>
                        </div>
                    </div>
                </div>
            </div>
        </div>

    </div>

</template>

<script setup>
import { useMatchStore } from '@/stores/match';
import { onMounted } from 'vue';
import { useRoute } from 'vue-router';

const route = useRoute()

const store = useMatchStore()

onMounted(() => {
    store.getMatch(route.params.id)
    store.getMatchAvgTier(route.params.id)
})


</script>

<style lang="scss" scoped></style>